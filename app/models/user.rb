require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email,:password,:password_confirmation

  has_many :microposts, :dependent => :destroy
  has_many :relationships, :dependent => :destroy,
                           :foreign_key => :follower_id
  has_many :following, :dependent => :destroy,
                       :through => :relationships,
                       :source => :followed
  has_many :reverse_relationships, :dependent => :destroy,
                       :foreign_key => "followed_id",
                       :class_name => "Relationship"
  has_many :followers, :dependent => :destroy, 
                       :through => :reverse_relationships,
                       :source => :follower
  
  #Experiment with scope
  scope :s_name, where('id > ?', 20)

  email_allowed = /\A[+.\w\d\-\_]+@[a-z\d]+\.[a-z]+\z/i  

  validates :name, :presence => true,
                   :length   => {:maximum => 50}
  validates :email, :presence => true,
                    :format => {:with =>email_allowed},
                    :uniqueness => {:case_sensitive => false}
  
  validates :password, :presence => true,
                       :confirmation =>true,
                       :length       =>{:within =>6..40}  

  before_save :encode_password

  def password_matches?(submitted_password)
    self.encrypted_password == encode(submitted_password)
  end

  def User.authenticate(email,submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.password_matches?(submitted_password)
  end

  def User.authenticate_with_salt(id,cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt)? user: nil
  end

  def feed
    return Micropost.where("user_id = ?",id)
  end


  def following?(user)
    #why find_by_xyz_id only need user as arg?
    relationships.find_by_followed_id(user)
  end

  def follow!(user)
    relationships.create!(:followed_id => user.id)
  end

  def unfollow!(user)
    relationships.find_by_followed_id(user).destroy
  end


  private 
  
    def encode_password
      self.salt = secure_hash("#{Time.now.utc}--#{self.password}") if new_record?
      self.encrypted_password = encode(self.password)
    end

    def encode(string)
      secure_hash("#{salt}--#{string}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
