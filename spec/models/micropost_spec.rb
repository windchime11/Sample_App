require 'spec_helper'

describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr ={
      :title => "New Post",
      :content => "This is first post. A test.",
    }
  end

  #this is supposed the way to get around read only attributes
  it "should create a new instance given valid structure" do
    @user.microposts.create!(@attr)
  end

  #<Test for associations with users
  describe "user associations" do

    #The way to create micropost without providing user_id
    before(:each) do
      @micropost = @user.microposts.create!(@attr)
    end

    it "should have a user attributes" do
      @micropost.should respond_to(:user)
    end

    # user_id is micropost attribute. user is caused by
    # association.
    it "should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end

  end
  #Test for associations with users>

  #<Test for micropost's own attributes
  describe "validation" do
    
    it "should require a user id" do
      Micropost.new(@attr).should_not be_valid
    end
    
    it "should require nonblank content" do
      ##@user has microposts.build(@attr) method due to has_many 
      #:microposts association
      #this .build is essentially equivalent to Micropost.new except
      #it automatically sets the micropost's user_id to @user.id
      @user.microposts.build(:content => "").should_not be_valid
    end

    it "should reject long content" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end

    it "should require nonblank title" do
      #here, to test :title, I have to set :content to a nonblank value
      # otherwise, it is always invalid
      @user.microposts.build(:title => "", :content => "abc").should_not be_valid
    end


  end

  #Test for micropost's own attributes>

end
