module Contentr
  module Contentrable
    extend ActiveSupport::Concern

    included do
      has_one :generated_page, class_name: 'Contentr::LinkedPage', as: :displayable

      after_create do
        created_page = self.create_generated_page!(name: "#{self.class.name.downcase} #{self.id}", slug: "#{self.id}", displayable: self, parent: Contentr::Site.last)
        Contentr::PageWithoutContent.create!(parent: created_page, name: 'seiten', slug: 'seiten')
      end
    end

    def sub_pages
      self.generated_page.children
    end

    def sub_pages=(pages)
      self.generated_page.children = sub_pages
    end

    def sub_pages?
      self.generated_page.children?
    end

    def parent_of_custom_pages
      self.sub_pages.find_by(slug: 'seiten')
    end

    module ClassMethods

    end # ClassMethods
  end
end
