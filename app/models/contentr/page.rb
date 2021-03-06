# coding: utf-8

module Contentr
  class Page < ActiveRecord::Base
    include Etikett::Taggable

    # Relations
    has_many :paragraphs, class_name: 'Contentr::Paragraph'
    belongs_to :displayable, polymorphic: true
    belongs_to :page_type, class_name: 'Contentr::PageType'
    belongs_to :page_in_default_language, class_name: 'Contentr::Page'
    has_many :sub_nav_items, class_name: 'Contentr::NavPoint', foreign_key: :parent_page_id
    has_many :pages_in_foreign_languages, class_name: 'Contentr::Page', foreign_key: :page_in_default_language_id

    acts_as_tree

    # Validations
    validates_presence_of   :name
    validates_presence_of   :slug
    validates :language, inclusion: FormTranslation.languages.map(&:to_s)

    # validates_format_of     :slug, with: /\A[a-z0-9\s-]+\z/
    # validates_presence_of   :path
    # validates_uniqueness_of :path, allow_nil: false, allow_blank: false
    validate                :check_nodes

    validate :slug_unique_within_siblings

    # Node checks
    class_attribute :run_node_checks
    class_attribute :accepted_child_nodes
    class_attribute :accepted_parent_nodes
    self.run_node_checks       = true
    self.accepted_parent_nodes = [:any]
    self.accepted_child_nodes  = [:any]

    # Callbacks
    before_validation :generate_slug
    before_validation :clean_slug
    after_save        :path_rebuilding

    master_tag do |page|
      if(klass = (page.parent.try(:displayable).presence || page.displayable.presence))
        prepended_name = "#{klass.master_tag.name} /"
      end
      if page.displayable.nil?
        name = "#{prepended_name} #{page.name}"
      else
        name = "#{prepended_name} Hauptseite"
      end

      {
        sid: name,
        nice: name
      }

    end


    attr_accessor :in_preview_mode
    # Node checks
    # self.accepted_parent_nodes = [Contentr::Page]
    # self.accepted_child_nodes  = [Contentr::Page]

    # Public: Find a Node by path
    #
    # path - The path to search for
    #
    # Returns the found path
    def self.find_by_path(path)
      self.where(url_path: ::File.join('/', path)).try(:first)
    end

    # Public: Gets the root element
    #
    # Returns the root of the tree the record is in, self for a root node
    def site
      self.root == self ? nil : self.root
    end


    # Public: Gets the classname of the page without Contentr in front
    #
    # Returns the class name as a string
    def classname
      self.class.to_s.split("::")[1].capitalize
    end

    # Public: Checks if self is a descendant of node
    #
    # node - The node which might be a direct or indirect ancestor
    #
    # Returns true if self is a descendant, false otherwise
    def descendant_of?(node)
      self.class.descendants_of(node).include?(self)
    end

    # Public: Raises an error if url_path is set directly
    #
    # value - the new value of url_path
    #
    # Returns a runtime error
    def url_path=(value)
      raise "url_path is generated and can't be set manually."
    end


    # Public: Gets the url path without the site name
    #
    # Example:
    #
    #  self.url_path = "/cms/foo/bar"
    #  => "/foo/bar"
    #
    # Returns the path without the site
    def site_path
      "/#{self.url_path.split('/').slice(2..-1).join('/')}"
    end

    # Public: Publishes the caller
    #
    # Sets published to true
    def publish!
      self.update_attribute(:published, true)
    end

    # Public: Checks if a page is visible
    #
    # Returns if visable or not
    def visible?
      self.published?
    end

    # Public: Fetches all visible and published children
    #
    # Returns the matching children
    def visible_children
      self.children.where(published: true)
    end

    # Public: gets all area_names of this page's paragraphs
    #
    # Returns an array of the found area_names without duplicates
    def expected_areas
      self.paragraphs.map(&:area_name).uniq
    end

    # Public: Searches for all paragraphs with an exact area_name
    #
    # area_name - the area_name to search for
    #
    # Returns the matching paragraphs
    def paragraphs_for_area(area_name)
      paragraphs = self.paragraphs.where(area_name: area_name).order("position asc")
      if self.in_preview_mode
        paragraphs = paragraphs.map(&:for_edit)
      end
      paragraphs
    end

    # Public: Getter for menu_only attribute
    #
    # Returns true or false
    def menu_only?
      self.children.none?
    end

    def preview!
      self.in_preview_mode = true
    end

    def stable!
      self.in_preview_mode = false
    end

    # Protected: Builts the url_path from ancestry's path
    #
    # Updates the url_path of the caller
    # def url_path
    #   @url_path ||= "/#{path.collect(&:slug).join('/')}"
    # end

    def url
      if self.page_in_default_language.present?
        PathMapper.locale = self.language
        current_page = self.page_in_default_language
      else
        current_page = self
      end
      url_path = "#{current_page.path.includes(:displayable).select{|p| p.displayable || p.id == current_page.id}.collect(&:url_map).compact.join('/')}".squeeze('/')
      PathMapper.locale = nil
      url_path
    end

    def parent_url
      if self.page_in_default_language.present?
        PathMapper.locale = self.language
        current_page = self.page_in_default_language
      else
        current_page = self
      end
      url_path = current_page.ancestors.includes(:displayable).select{|p| p.displayable || p.id == current_page.id}.collect(&:url_map).compact
      if current_page.displayable.nil? && current_page.parent.displayable.present?
        url_path << Contentr.divider_between_page_and_children
      end
      PathMapper.locale = nil
      url_path.join('/').squeeze('/')
    end

    def url_map
      if self.displayable.present?
        p = PathMapper.new(self.displayable)
        p.path
      elsif self.parent.try(:displayable).present?
        [Contentr.divider_between_page_and_children, self.url_path].join('/').squeeze('/')
      else
        self.url_path
      end
    end

    def url_slug
      if self.displayable.present?
        nil
      else
        self.slug
      end
    end

    def areas
      if self.page_type.present?
        self.page_type.areas
      else
        []
      end
    end

    def publish!
      self.paragraphs.each(&:publish!)
      self.update(published: true)
    end

    def hide!
      self.update(published: false)
    end

    def get_page_for_language(language, fallback: true)
      return self if self.language == language.to_s
      translated_page = self.pages_in_foreign_languages.includes(:paragraphs).find_by(language: language.to_s)
      translated_page || (fallback ? self : nil)
    end

    def default_page
      self.page_in_default_language.present? ? self.page_in_default_language : self
    end

    def self.default_page_for_slug(slug)
      self.find_by(slug: slug, page_in_default_language_id: nil)
    end

    def viewable?(preview_mode: false)
      self.present? && (self.visible? || preview_mode)
    end

    protected

    # Protected: Generates a slug from the name if a slug is not yet set
    #
    # Returns a clean slug
    def generate_slug
      if name.present? && slug.blank?
        self.slug = name.to_s.to_slug
      end
    end

    # Protected: Removes unwanted chars from a slug
    #
    # Returns a clean slug
    def clean_slug
     self.slug = slug.to_s.to_slug unless slug.blank?
    end

    # Protected: Builts the url_path from ancestry's path
    #
    # Updates the url_path of the caller
    def path_rebuilding
      if self.displayable.nil?
        self.subtree.each do |page|
          page.rebuild_path!
        end
      end
    end

    def rebuild_path!
      local_path = self.path.reject{|p| p.is_a?(Contentr::LinkedPage)}
      new_path = "#{local_path.collect(&:url_slug).compact.join('/')}".gsub(/\/+/, '/')
      new_path = new_path.prepend('/') unless new_path.start_with?('/')
      self.update_column(:url_path,  new_path) if self.displayable.nil?
    end

    # Protected: Checks if this is a valid node
    #
    # Adding errors if this node is not valid
    def check_nodes
      # errors.add(:base, "Unsupported parent node.") unless accepts_parent?(parent)
      # errors.add(:base, "Unsupported child node.")  if parent.present? and not parent.accepts_child?(self)
    end

    def slug_unique_within_siblings
      cnt = self.siblings.select{|s| s.slug == self.slug && s.id != self.id}.count
      errors.add(:slug, :must_be_unique) if cnt > 0
    end

    # Protected: Checks if this node accepts a child node
    #
    # child - the child node to test against
    #
    # Returns true if this child is accepted, false otherwise
    def accepts_child?(child)
      return true if accepted_child_nodes.include?(:any)
      return accepted_child_nodes.any?{ |node_class| node_class.kind_of?(Class) and child.is_a?(node_class) }
    end

    # Protected: Checks if this node accepts a parent
    #
    # parent - the parent node to test against
    #
    # Returns true if this parent is accepted, false otherwise
    def accepts_parent?(parent)
      return true  if self.accepted_parent_nodes.include?(:any)
      return true  if self.is_root? && self.accepted_parent_nodes.include?(:root)
      return false if self.is_root? && !self.accepted_parent_nodes.include?(:root)
      return self.accepted_parent_nodes.any?{ |node_class| node_class.kind_of?(Class) && parent.is_a?(node_class) }

    end


  end
end
