class BoardGroup < ActiveRecord::Base
  attr_accessible :name, :item_order
  has_many :boards, :dependent => :destroy, :order => 'item_order'
end
