class CreatePages < ActiveRecord::Migration[7.2]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :icon
      t.string :cover_image
      t.references :workspace, null: false, foreign_key: true
      t.references :creator, polymorphic: true, null: false
      t.boolean :is_template
      t.boolean :is_archived

      add_foreign_key :pages, :pages, :column: :page_id

      t.timestamps
    end
  end
end
