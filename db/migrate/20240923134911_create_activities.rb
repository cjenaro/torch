class CreateActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :activities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workspace, null: false, foreign_key: true
      t.string :action
      t.string :trackable_type
      t.integer :trackable_id

      t.timestamps
    end
  end
end
