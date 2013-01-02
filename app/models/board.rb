class Board < ActiveRecord::Base
  attr_accessible :board_group_id, :description, :name, :item_order, :posts_number
  belongs_to :board_group
end
