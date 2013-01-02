class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :name
      t.integer :rating
      t.boolean :pinned
      t.integer :user_id
      t.integer :board_id

      t.timestamps
    end
  end
end
