require 'spec_helper'

describe "pages" do

  # let!(:site) { FactoryGirl.create(:site, slug: "foobar") }
  # let!(:contentpage) { FactoryGirl.create(:contentpage_with_paragraphs) }

  # it "displays the page name" do
  #   visit "/cms"
  # end

  # it "has two paragraphs" do
  #   visit("/cms/foo")
  #   page.all(:css, '.paragraph').count.should be(2)
  # end

  # it "has got a link to the parent" do
  #   visit "/foo"
  #   page.find_link("cms")
  #   click_link("cms")
  #   current_path.should eql "/"
  # end

  it 'displays the content' do
    site = build(:site, slug: 'en')
    a = Article.create!(title: 'wicked product', body: 'this article is awesome!')
    content_page = a.sub_pages.create(name: 'info')
    paragraph = create(:paragraph, page: content_page, body: 'hello world!').publish!
    visit "/en/articles/#{a.id}/seiten/info"
    expect(page).to have_content('hello world!')
  end
end
