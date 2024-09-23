class FixParentForeignKeyOnPages < ActiveRecord::Migration[7.2]
  def change
    remove_foreign_key :pages, column: :parent_id

    add_foreign_key :pages, :pages, column: :parent_id
  end
end
