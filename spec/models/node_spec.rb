# coding: utf-8

require 'spec_helper'

describe Contentr::Page do

  it "create a single node" do
    node = Contentr::Page.create!(name: "Node33")
  end

  it "always has a name" do
    page = Contentr::Page.new(name: '')
    page.should_not be_valid
  end

  it "has an auto generated slug" do
    page = Contentr::Page.create!(name: "Node44")
    page.slug.should eql "node44"
  end

  it "slug can be set to a custom value" do
    page = Contentr::Page.create!(name: 'Node1', slug: 'test-page')
    page.slug.should eql 'test-page'
  end

  it 'slug matches the format /^[a-z0-9\s-]+$/' do
    page = Contentr::Page.new(:name => 'Some other Page')

    ['abc', '123', '123abc', 'abc123', 'abc-123', 'abc_123', 'abc+123', 'abc_123', 'öäüß'].each do |p|
      page.slug = p
      page.should be_valid, page.errors.full_messages.join('; ')
    end
  end

  it 'slug is unique within the parent scope' do
    page1 = Contentr::Page.create!(:name => 'Some Page', :slug => 'it-page')
    page2 = Contentr::Page.new(:name => 'Some other Page', :slug => 'it-page')
    page2.should_not be_valid
    assert_equal page2.errors.first[0], :slug
    assert_equal page2.errors.first[1], 'must be unique'
    # .. but we can use the same slug in another parent scope
    page2 = Contentr::Page.new(:name => 'Some other Page', :slug => 'it-page', :parent => page1)
    page2.should be_valid, page2.errors.full_messages.join('; ')
  end

  it 'has a generated path' do
    site = create(:site)
    page1 = Contentr::Page.create!(name: 'Page 1', slug: 'page1', parent: site).reload
    page2 = Contentr::Page.create!(:name => 'Page 2', :slug => 'page2', :parent => page1).reload
    page3 = Contentr::Page.create!(:name => 'Page 3', :slug => 'page3', :parent => page2).reload
    page1.url_path.should eql '/page1'
    page2.url_path.should eql '/page1/page2'
    page3.url_path.should eql '/page1/page2/page3'
  end

  it 'path can\'t be set manually' do
    page = Contentr::Page.create!(:name => 'Page 1', :slug => 'page1').reload
    page.url_path.should eql '/page1'
    lambda { page.url_path = 'this_is_not_allowed' }.should raise_error(RuntimeError)
  end

  it 'one can find a node by path' do
    site = create(:site)
    page1 = Contentr::Page.create!(name: 'Page 1', slug: 'page1', parent: site)
    page2 = Contentr::Page.create!(:name => 'Page 2', :slug => 'page2', :parent => page1)
    page3 = Contentr::Page.create!(:name => 'Page 3', :slug => 'page3', :parent => page2)
    expect(Contentr::Page.find_by_path('/page1')).to eq page1
    expect(Contentr::Page.find_by_path('/page1/page2')).to eq page2
    expect(Contentr::Page.find_by_path('/page1/page2/page3')).to eq page3
    expect(Contentr::Page.find_by_path('/no_such_page')).to be_nil
  end
end
