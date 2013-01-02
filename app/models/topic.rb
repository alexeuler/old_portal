class Topic < ActiveRecord::Base
  attr_accessible :board_id, :name, :pinned, :rating, :user_id
end
