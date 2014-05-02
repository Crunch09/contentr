module Contentr
  class PageBuilder
    attr_accessor :parent, :main_page_type, :obj

    def initialize(hash = {})
      @parent = hash.fetch :parent, nil
      @main_page_type = hash.fetch :main_page_type, nil
      @obj = hash.fetch :obj, nil
    end

    def create name, slug: nil, en: nil, page_type: nil, publish: true, removable: false, for_object: false, &block
      ActiveRecord::Base.transaction do
        page_type = page_type.presence || main_page_type
        if name.respond_to?(:call)
          real_name = name.instance_exec(obj, &name)
        else
          real_name = name
        end
        page = Contentr::Page.new(name: real_name,
          language: FormTranslation.default_language.to_s,
          parent: self.parent,
          page_type: page_type,
          published: publish,
          removable: false)
        page.displayable = obj if for_object
        page.slug = slug if slug.present?
        page.save!
        nav_point = Contentr::NavPoint.create!(title: real_name, page: page, parent_page: page.parent, en_title: en, removable: removable)
        if block_given?
          page_builder = Contentr::PageBuilder.new(parent: page, main_page_type: page.page_type, obj: self.obj)
          page_builder.instance_exec(nil, &block)
        end
      end
    end
  end
end
