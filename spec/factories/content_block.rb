FactoryGirl.define do
  factory :content_block, class: Contentr::ContentBlock do |s|
    s.name "content block"
    s.language "en"
    s.partial '_article'
  end
end
