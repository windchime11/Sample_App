require 'spec_helper'

describe Relationship do

  before(:each) do
    @follower = Factory(:user)
    @followed = Factory(:user, :email => Factory.next(:email))
    
    @relationship = @follower.relationships.build(:followed_id => @followed.id)
  end

  it "should create a new instance given valid attributes" do
    @relationship.save!
  end


  describe "follow methods" do
    
    before(:each) do
      @relationship.save
    end

    it "should have the right follower" do
      @relationship.follower.should == @follower
    end

    it "should have the right followed" do
      @relationship.followed.should == @followed
    end

  end

  describe "attribute validation" do

    it "should have a follower" do
      @relationship.follower_id = nil
      @relationship.should_not be_valid
    end


    it "should have a follower" do
      @relationship.followed_id = nil
      @relationship.should_not be_valid
    end

  end


end
