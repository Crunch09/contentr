# coding: utf-8

require 'spec_helper'

describe Contentr::Page do
  it 'site must be a root' do
    site1 = Contentr::Site.new(name: 'site1')
    site1.should be_valid
    site1.save!
    site2 = Contentr::Site.new(name: 'site1', parent: site1)
    site2.should be_invalid
  end

  it 'page must have parent' do
    page = Contentr::Page.new(name: 'page1')
    page.should be_valid
  end

  it 'the parent of a page must be of type Contentr::Page' do
    site = Contentr::Site.create!(name: 'site')
    page = Contentr::Page.new(name: 'page', parent: site)
    site.should be_valid
    page.should be_valid

    node = Contentr::Page.create!(name: 'node')
    page = Contentr::Page.new(name: 'page', parent: node)
    node.should be_valid
    page.should be_valid
  end

  it 'children of a page must be of type Contentr::Page' do
    site = Contentr::Site.create!(name: 'site')
    page = Contentr::Page.create!(name: 'page', parent: site)
    site.should be_valid
    page.should be_valid

    node = Contentr::Site.new(name: 'node', parent: page)
    node.should be_invalid
  end

  describe '#url' do
    it "gets the url for a main page of an object" do
      site = create(:site, name: 'en', slug: 'en')
      a = Article.create!(title: 'awesome product', body: 'hell yeah!').reload
      expect(a.generated_page.url).to eq "/en/articles/#{a.id}"
    end

    it "gets the url for a custom subpage" do
      site = create(:site, name: 'en', slug: 'en')
      a = Article.create!(title: 'awesome product', body: 'hell yeah!')
      custom_page = Contentr::Page.create(name: 'foo', parent: a.parent_of_custom_pages).reload
      expect(custom_page.url).to eq "/en/articles/#{a.id}/seiten/foo"
    end
  end
end
