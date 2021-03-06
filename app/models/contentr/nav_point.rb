module Contentr
  class NavPoint < ActiveRecord::Base
    include FormTranslation::ForModel

    belongs_to :site, class_name: 'Contentr::Site'
    belongs_to :page
    belongs_to :parent_page, class_name: 'Contentr::Page'
    after_create :set_actual_position!
    before_save :set_page_from_tag

    validate :site, presence: true
    validate :url_xor_page

    translate_me :title

    acts_as_tree

    attr_accessor :page_tag

    def only_link?
      self.page.nil?
    end

    def self.navigation_tree
      self.where(parent_page_id: nil).includes(page: :page_in_default_language).arrange
    end

    def set_actual_position!
      if self.ancestry.present?
        last_position = self.siblings.where.not(id: self.id).order('position DESC').limit(1)
      else
        last_position = self.class.where(parent_page_id: self.parent_page_id).where.not(id: self.id).order('position DESC').limit(1)
      end
      if last_position.any?
        self.update_columns(position: last_position.first.position + 1)
      end
    end

    def link
      if self.page.present?
        self.page.url
      elsif self.url.present?
        self.url
      end
    end

    def set_page_from_tag
      if self.page_tag.present?
        tag = Etikett::Tag.find(self.page_tag)
        self.page = tag.prime.default_page
      end
    end

    def set_tag_from_page
      if self.page.present?
        self.page_tag = self.page.master_tag
      end
    end

    def self.navigation_roots
      roots.where(parent_page_id: nil)
    end

    private

    def url_xor_page
      if [page, url].compact.select(&:present?).count > 1
        errors.add(:url, :page_and_url_are_mutual_exclusive)
      end
    end
  end
end
