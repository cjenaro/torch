class CreateDatabaseEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :database_entries do |t|
      t.references :block, null: false, foreign_key: true
      t.json :properties

      t.timestamps
    end
  end
end
