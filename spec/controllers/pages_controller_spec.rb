require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end


  describe "GET 'home'" do
    
    describe "when not signed-in" do
      before(:each) do
        get 'home'
      end
    
      it "should be successful" do
        response.should be_success
      end

      it "should have the right tile" do
        response.should have_selector("title",
                                    :content => "#{@base_title} | Home")
      end
    end
    
    describe "when signed in" do
    
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end

     it "should have following and follower" do
        get 'home'
        response.should have_selector("a", :href => following_user_path(@user),
                                    :content => "0")
        response.should have_selector("a", :href => followers_user_path(@user),
                                    :content => "1")
     end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right tile" do
      get 'contact'
      response.should have_selector("title",
                                    :content => "#{@base_title} | Contact")
      end

  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

        it "should have the right tile" do
      get 'about'
      response.should have_selector("title",
                                    :content => "#{@base_title} | About")
      end

  end

end

