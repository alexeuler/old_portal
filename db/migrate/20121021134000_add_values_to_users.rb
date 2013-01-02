class AddValuesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :status, :string
    add_column :users, :posts_number, :integer
    add_column :users, :ava_url, :string
    add_column :users, :role, :string
  end
end
