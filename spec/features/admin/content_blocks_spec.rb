require 'spec_helper'

describe Contentr::Admin::ContentBlocksController do
  describe '#edit' do

    it 'is able to add paragraphs to the content block', js: true do
      Contentr.default_areas = [:main]
      content_block = create(:content_block)
      content_block.update_column(:partial, '')
      visit contentr.edit_admin_content_block_path(content_block)
      within('.new-paragraph-buttons') do
        click_link 'HTML'
      end
      within('.existing-paragraphs form') do
        fill_in 'Body', with: 'hello world!'
        click_button 'Save Paragraph'
      end
      # expect(page.find(".paragraph")).to have_content('hello world!')
    end
  end
end
