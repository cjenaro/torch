class ChangeParentIdToAllowNullInPages < ActiveRecord::Migration[7.2]
  def change
    change_column_null :pages, :parent_id, true
  end
end
