class CreateBoardGroups < ActiveRecord::Migration
  def change
    create_table :board_groups do |t|
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
