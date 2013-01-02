class RenameOrderColumns < ActiveRecord::Migration
  def up
    rename_column :boards, :order, :item_order
    rename_column :board_groups, :order, :item_order
  end

  def down
    rename_column :boards, :item_order, :order
    rename_column :board_groups, :item_order, :order
  end
end
