class CreateContentrParagraphs < ActiveRecord::Migration
  def self.up
    create_table :contentr_paragraphs do |t|
      t.string 'area_name'
      t.integer 'position'
      t.string 'type'
      t.text 'data'
      t.text 'unpublished_data'
      t.references 'page'
      t.timestamps
    end
  end

  def self.down
    drop_table :contentr_paragraphs
  end
end
