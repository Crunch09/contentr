FactoryGirl.define do
  factory :contentpage, class: Contentr::ContentPage do |c|
    c.name "Foo"
    c.slug "foo"
    c.published true
    c.hidden false
    factory :contentpage_with_paragraphs do
      after(:create) do |contentpage, evaluator|
        FactoryGirl.create_list(:paragraph, 2, page: contentpage)
      end
    end
    factory :contentpage_with_content_block do
      after(:create) { |instance| create(:content_block_usage, page: instance, area_name: :body, position: 0)}
    end
  end
end
