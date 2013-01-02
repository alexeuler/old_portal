class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name
      t.string :description
      t.integer :posts_number
      t.integer :order
      t.integer :board_group_id

      t.timestamps
    end
  end
end
