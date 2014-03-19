require 'spec_helper'

describe Contentr::NavPoint do

  describe 'general stuff' do
    it "works" do
      site = Contentr::Site.create!(name: 'en')
      nav_point = Contentr::NavPoint.create!(title: 'Articles', site: site)
    end
  end

  describe '#only_link?' do
    it 'it knows when its only a link' do
      site = Contentr::Site.create!(name: 'en')
      nav_point = Contentr::NavPoint.create!(title: 'Articles', site: site)
      expect(nav_point.only_link?).to be_truthy
      p = Contentr::Page.new
      nav_point.displayable = p
      expect(nav_point.only_link?).to be_falsey
    end
  end
end
