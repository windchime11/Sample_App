require 'spec_helper'

describe RelationshipsController do

  before(:each) do
    @user =Factory(:user)
  end


  describe "access control" do
    it "can not create without signin" do
      post :create
      response.should redirect_to(signin_path) 
    end

    it "can not destroy without signin" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path) 
    end
  end

  #<Test for follow/unfollow button
  describe "POST create" do
    
    before(:each) do
      test_sign_in(@user)
      @followed = Factory(:user, :email => Factory.next(:email))
    end

    it "can create after sign in" do
      lambda do
        post :create, :relationship => {:followed_id => @followed}
        response.should be_redirect
      end.should change(Relationship,:count).by(1) 
    end
    
    it "should create using ajax" do
      lambda do
        xhr :post, :create, :relationship => {:followed_id => @followed}
        response.should be_success
      end.should change(Relationship, :count).by(1)
    end

  end

  describe "DELETE destroy" do

    before(:each) do
      test_sign_in(@user)
      @followed = Factory(:user, :email => Factory.next(:email)) 
      @user.follow!(@followed)
      @relationship = @user.relationships.find_by_followed_id(@followed)
   end


    it "can destroy after signin" do
      lambda do
      delete :destroy, :id => @relationship
      response.should be_redirect 
      end.should change(Relationship, :count).by(-1)
    end


    it "can destroy after signin using ajax" do
      lambda do
      xhr :delete, :destroy, :id => @relationship
      response.should be_success
      end.should change(Relationship, :count).by(-1)
    end

  end

  #Test for follow/unfollow button>



end
