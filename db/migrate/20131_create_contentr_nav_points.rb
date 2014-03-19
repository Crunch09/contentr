class CreateContentrNavPoints < ActiveRecord::Migration
  def change
    create_table :contentr_nav_points do |t|
      t.references :displayable, polymorphic: true
      t.references :site
      t.string :title
      t.string :ancestry
      t.integer :position, default: 0

      t.index :ancestry

      t.timestamps
    end
  end
end
