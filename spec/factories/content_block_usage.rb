FactoryGirl.define do
  factory :content_block_usage, class: Contentr::ContentBlockUsage do |c|
    association :page, factory: :content_page
    c.content_block
    c.area_name :body
    c.position 0
  end
end
