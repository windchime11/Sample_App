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

  #<Test for table associations
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
  #Test for table associations>

end
