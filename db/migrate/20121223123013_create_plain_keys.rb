class CreatePlainKeys < ActiveRecord::Migration
  def change
    create_table :plain_keys do |t|
      t.string :key
      t.string :iv
      t.timestamps
    end
  end
end
