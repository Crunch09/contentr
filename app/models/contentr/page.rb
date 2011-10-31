# coding: utf-8

module Contentr
  class Page < Node

    # Includes
    include Rails.application.routes.url_helpers

    # Fields
    field :description, :type => String
    field :layout,      :type => String, :default => 'default'
    field :template,    :type => String, :default => 'default'
    field :linked_to,   :type => String, :index => true
    field :menu_title,  :type => String
    field :published,   :type => Boolean, :default => false, :index => true
    field :hidden,      :type => Boolean, :default => false, :index => true

    # Relations
    embeds_many :paragraphs, :class_name => 'Contentr::Paragraph'

    # Protect attributes from mass assignment
    attr_accessible :description, :layout, :template, :linked_to, :hidden, :published

    # Validations
    validates_presence_of   :layout
    validates_presence_of   :template
    validates_uniqueness_of :linked_to, :allow_nil => true, :allow_blank => true

    # Constraints
    self.accepted_parent_nodes = ["Contentr::Workspace", "Contentr::Page"]
    self.accepted_child_nodes  = ["Contentr::Page"]


    def self.find_by_path(path)
      if path.present? and path.start_with?(Contentr.frontend_route_prefix)
        path = path.slice(Contentr.frontend_route_prefix.length..path.length)
      end
      Contentr::Page.where(:path => path).try(:first)
    end

    def self.find_linked_page_by_request_params(params)
      controller = params[:controller]
      action = params[:action]
      id = params[:id]
      return if controller.blank?
      return if action.blank?

      wildcard_pattern = "#{controller}#*"
      default_pattern = "#{controller}##{action}"
      full_pattern = "#{default_pattern}:#{id}" if id.present?

      if full_pattern.present?
        page = Contentr::Page.where(linked_to: full_pattern).try(:first)
        return page if page.present?
      end

      page = Contentr::Page.where(linked_to: default_pattern).try(:first)
      return page if page.present?

      page = Contentr::Page.where(linked_to: wildcard_pattern).try(:first)
      return page if page.present?
    end

    def is_link?
      linked_to.present?
    end

    def url_for_linked_page(options = {})
      if is_link?
        begin
          p = linked_to.split('#')

          controller = p.first
          controller = "/#{controller}" unless controller.include?('/')

          action, id = p.last.split(':')
          action = 'index' if action.blank? or action.strip == '*'

          options = options.merge(controller: controller, action: action, only_path: true)
          options = options.merge(id: id) if id.present?

          url_for(options)
        rescue Exception => e
          Rails.logger.error(e)
          # in case we could not create a proper backlink url we will silently
          # fail with the app's root url.
          root_url(only_path: true)
        end
      end
    end

    def expected_areas
      paragraphs.map(&:area_name).uniq
    end

    def paragraphs_for_area(area_name)
      paragraphs.where(area_name: area_name).order_by([[:position, :asc]])
    end

    def publish!
      self.update_attribute(:published, true)
    end

    def visible?
      self.published? and not self.hidden?
    end

    def visible_children
      self.children.where(published: true, hidden: false)
    end

  end
end
