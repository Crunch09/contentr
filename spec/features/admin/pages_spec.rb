require 'spec_helper'

describe Contentr::Admin::PagesController do
  let!(:site) { FactoryGirl.create(:site, slug: "foobar") }
  let!(:contentpage) { FactoryGirl.create(:contentpage_with_paragraphs) }

  describe "#index" do
    before { visit "/contentr/admin/pages" }

    it "has an index path" do
      current_path.should eql contentr.admin_pages_path
    end

    it "has a list of all root pages" do
      page.find(:css, 'table#pages_table').should_not be_nil
    end

    it "has one site in this list" do
      page.all(:css, 'table#pages_table tbody tr').count.should be(1)
    end

    it "has a create new site link" do
      page.should have_link "Create a new site"
    end

    it "has a link to edit the site" do
      page.should have_selector("i.fa.fa-edit")
    end

    it "has a link to delete the page" do
      page.should have_selector("i.fa.fa-remove")
    end

    it "lists the current path" do
      page.should have_content("Current Path: /")
    end
  end

  describe "#index" do
    before { visit contentr.admin_pages_path(root: contentpage.id)}

    it "shows the paragraphs of the page" do
      pending 'old code'
      page.all(:css, '.paragraph').count.should be(2)
    end

    it "deletes a paragraph when i click on delete" do
      pending 'old code'
      within("#paragraph_1") do
        page.find("a.remove-paragraph-btn").click
      end
      expect(contentpage.paragraphs.count).to be 1
    end

    it "shows the unpublished version of a paragraph if there is one" do
      pending 'old code'
      para = Contentr::Paragraph.find(contentpage.paragraphs.first.id)
      para.body = "hell yeah!"
      para.save!
      visit(contentr.admin_pages_path(root: contentpage.id))
      expect(page).to have_content("hell yeah!")
    end
  end

  describe '#show' do
    it 'displays the page\'s areas' do
      Contentr.default_areas = [:main]
      page = create(:contentpage, name: 'bar', slug: 'bar')
      visit contentr.admin_page_path(page)
      within('.panel-title') do
        page.areas.each do |area|
          expect(page).to have_content(area)
        end
      end
    end

    it 'is able to add paragraphs to areas', js: true do
      Contentr.default_areas = [:main]
      contentr_page = create(:contentpage, name: 'bar', slug: 'bar')
      visit contentr.admin_page_path(contentr_page)
      within('.new-paragraph-buttons') do
        click_link 'HTML'
      end
      within('.existing-paragraphs form') do
        fill_in 'Body', with: 'hello world!'
        click_button 'Save Paragraph'
      end
      expect(page.find(".paragraph")).to have_content('hello world!')
    end
  end

end
