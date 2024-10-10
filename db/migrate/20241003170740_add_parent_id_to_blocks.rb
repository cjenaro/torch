class AddParentIdToBlocks < ActiveRecord::Migration[7.2]
  def change
    add_column :blocks, :parent_id, :integer
    add_index :blocks, :parent_id
  end
end
