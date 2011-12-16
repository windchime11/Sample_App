class Micropost < ActiveRecord::Base
  attr_accessible :content, :title
  belongs_to :user

  default_scope :order => 'microposts.created_at DESC'

  validates :content, :presence => true, :length => {:maximum => 140}
  validates :title,   :presence => true
  validates :user_id, :presence => true

end
