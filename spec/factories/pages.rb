FactoryGirl.define do
  factory :contentpage, class: Contentr::ContentPage do |c|
    c.name 'Foo'
    c.slug 'foo'
    c.published true
    c.language 'en'
    c.page_type
    factory :contentpage_with_paragraphs do
      after(:create) do |contentpage, evaluator|
        FactoryGirl.create_list(:paragraph, 2, page: contentpage)
      end
    end
    factory :contentpage_with_content_block_paragraph do
      after(:create) { |instance| create(:content_block_paragraph, page: instance, area_name: :center_column, position: 0)}
    end
  end
end
