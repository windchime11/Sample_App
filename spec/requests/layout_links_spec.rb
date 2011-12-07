require 'spec_helper'

describe "LayoutLinks" do
  it "should have a homepage at '/'" do
      get '/'
      response.should have_selector('title',:content=> "Home")
  end

  it "should have about page at '/about'" do
      get '/about'
      response.should have_selector('title',:content=> "About")
  end

  it "should have a homepage at '/contact'" do
      get '/contact'
      response.should have_selector('title',:content=> "Contact")
  end
  it "should have a homepage at '/help'" do
      get '/help'
      response.should have_selector('title',:content=> "Help")
  end

  it "should have a sign up page at '/signup'" do
    get '/signup'
    response.should have_selector('title',:content => "Sign Up")
  end
  
  describe "when not signed in " do
    it "should have a sign-in link for non-signed in users" do
      visit root_path
      response.should have_selector("a", :href => signin_path, 
                                         :content => "Sign In")
    end
  end

  describe "when signed in" do

    before(:each) do 
      @user = Factory(:user)
      visit signin_path
      fill_in :email, :with =>@user.email
      fill_in :password, :with => @user.password
      click_button
    end
      

    it "should have a sign-out page for signed in user" do
      visit root_path
      response.should have_selector("a",:href => signout_path,
                                        :content => "Sign Out")
    end

    it "should have a profile link for signed in user" do
      visit root_path
      response.should have_selector("a",:href => user_path(@user), 
                                        :content => "My Profile")
    end

  end


end
