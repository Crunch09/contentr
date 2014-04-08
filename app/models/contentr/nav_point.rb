module Contentr
  class NavPoint < ActiveRecord::Base
    self.table_name = 'contentr_nav_points'

    belongs_to :site, class_name: 'Contentr::Site'
    belongs_to :page
    belongs_to :parent_page, class_name: 'Contentr::Page'
    after_create :set_actual_position!

    validate :site, presence: true

    acts_as_tree

    def only_link?
      self.page.nil?
    end

    def self.navigation_tree
      self.arrange
    end

    def set_actual_position!
      last_position = self.siblings.where.not(id: self.id).order('position DESC').limit(1)
      if last_position.any?
        self.position = last_position.first.position + 1
      end
    end

    def link
      if self.page.present?
        self.page.url
      elsif self.url.present?
        self.url
      end
    end
  end
end
