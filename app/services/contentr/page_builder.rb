module Contentr
  class PageBuilder
    attr_accessor :parent

    def create name, slug: nil
      page = Contentr::Page.new(name: name, language: FormTranslation.default_language.to_s, parent: self.parent)
      page.slug = slug if slug.present?
      page.save
    end
  end
end
