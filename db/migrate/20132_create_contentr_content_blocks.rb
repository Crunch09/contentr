class CreateContentrContentBlocks < ActiveRecord::Migration
  def change
    create_table :contentr_content_blocks do |t|
      t.string :name
      t.string :language
      t.string :partial
      t.string :visible, default: true
      t.timestamps
    end

    create_table :contentr_content_blocks_pages do |t|
      t.references :content_block
      t.references :page
      t.timestamps
    end
  end
end
