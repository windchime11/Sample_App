class Micropost < ActiveRecord::Base
  attr_accessible :content, :title
  belongs_to :user

  default_scope :order => 'microposts.created_at DESC'
  scope :from_users_followed_by, lambda {|user| followed_by(user)}

  validates :content, :presence => true, :length => {:maximum => 140}
  validates :title,   :presence => true
  validates :user_id, :presence => true

  private
     def self.followed_by(user)
       followed_ids = %(SELECT followed_id FROM relationships WHERE follower_id = :user_id)
       where("user_id IN (#{followed_ids}) OR user_id = :user_id",{:user_id => user.id})
     end


end
