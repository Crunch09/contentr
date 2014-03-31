require 'spec_helper'

describe Contentr::Admin::ParagraphsController do

  let!(:site) { FactoryGirl.create(:site, slug: "foobar") }
  let!(:contentpage) { FactoryGirl.create(:contentpage_with_paragraphs) }

  describe "#edit" do
    before { visit(contentr.edit_admin_paragraph_path(contentpage.paragraphs.first))}

    context "up-to-date" do

      it "has an up-to-date button" do
        expect(page).to have_content('No unpublished changes')
      end

      it "has no revert button" do
        expect(page).to_not have_button("Revert")
      end

      it "updates its body" do
        fill_in("paragraph_body", with: "Foobar")
        click_button("Save Paragraph")
        visit(contentr.edit_admin_paragraph_path(contentpage.paragraphs.first))
        page.find(:css, "textarea#paragraph_body").value.should eql "Foobar"
      end
    end

    context "unpublished changes" do

      it "has a publish button" do
        expect(page).to have_content('Publish!')
      end
    end
  end

  describe "#publish" do

    it "resets the publish button if i click on it" do
      # pending 'needs polishing'
      @para = contentpage.paragraphs.first
      @para.body = "hell yeah"
      @para.save!
      visit(contentr.edit_admin_paragraph_path(@para))
      click_link("Publish!")
      page.has_content?("No unpublished changes")
    end
  end

end
