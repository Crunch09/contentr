class CreateContentrPages < ActiveRecord::Migration
  def self.up
    create_table :contentr_pages do |t|
      t.string 'name'
      t.string 'slug'
      t.string 'type'
      t.string 'menu_title'
      t.boolean 'published', default: false
      t.boolean 'hidden', default: false
      t.string 'layout', default: "application"
      t.string 'linked_to'
      t.string 'ancestry'
      t.string 'url_path'
      t.references :page_type
      t.references :displayable, polymorphic: true
      t.timestamps
    end
    add_index :contentr_pages, :published
    add_index :contentr_pages, :hidden
    add_index :contentr_pages, :ancestry
  end

  def self.down
    drop_table :contentr_pages
  end
end
