class CreateBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :blocks do |t|
      t.string :block_type
      t.text :content
      t.json :data
      t.integer :position
      t.references :page, null: false, foreign_key: true

      t.timestamps
    end
  end
end
