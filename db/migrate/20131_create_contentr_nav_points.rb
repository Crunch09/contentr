class CreateContentrNavPoints < ActiveRecord::Migration
  def change
    create_table :contentr_nav_points do |t|
      t.references :page
      t.references :site
      t.string :title
      t.string :ancestry
      t.string :url
      t.references :parent_page
      t.integer :position, default: 0
      t.string :type
      t.text :payload
      t.index :ancestry

      t.timestamps
    end
  end
end
