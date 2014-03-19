class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string 'name'
      t.string 'slug'
      t.string 'type'
      t.string 'menu_title'
      t.boolean 'published', default: false
      t.boolean 'hidden', default: false
      t.string 'layout', default: "application"
      t.string 'template', default: "default"
      t.string 'linked_to'
      t.string 'ancestry'
      t.string 'url_path'
      t.references :displayable, polymorphic: true
      t.timestamps
    end
    add_index :pages, :published
    add_index :pages, :hidden
    add_index :pages, :ancestry
  end

  def self.down
    drop_table :pages
  end
end
