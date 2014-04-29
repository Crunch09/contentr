module Contentr
  class PageBuilder
    attr_accessor :parent, :main_page_type

    def create name, slug: nil, en: nil, page_type: nil, publish: true
      ActiveRecord::Base.transaction do
        page_type = page_type.presence || main_page_type
        page = Contentr::Page.new(name: name,
          language: FormTranslation.default_language.to_s,
          parent: self.parent,
          page_type: page_type,
          publish: publish)
        page.slug = slug if slug.present?
        page.save!
        nav_point = Contentr::NavPoint.create!(title: name, page: page, parent_page: page.parent, en_title: en)
      end
    end
  end
end
