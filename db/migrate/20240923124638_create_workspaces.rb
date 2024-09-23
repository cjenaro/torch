class CreateWorkspaces < ActiveRecord::Migration[7.2]
  def change
    create_table :workspaces do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
