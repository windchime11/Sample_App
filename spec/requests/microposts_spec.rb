require 'spec_helper'

describe "Microposts" do

  before(:each) do
    @user = Factory(:user)
    #The reason that Factory(:user) can be signed in
    #is that db:populate used Factory(:user)
    visit signin_path
    fill_in :email, :with => @user.email
    fill_in :password, :with => @user.password
    click_button
  end

  describe "creation" do
    
    describe "failure" do
      
      it "should show home page for signed in user" do
        visit root_path
        response.should have_selector("h1",:content=>"What's up")
      end

      it "should not make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_title, :with => ""
          fill_in :micropost_content, :with => ""
          click_button
          #This should be equivalent to redirect_to(root_path)
          response.should render_template('pages/home')
          response.should have_selector("div", :content => "Unable to create")
        end.should_not change(Micropost, :count)
      end

      it "should make a new micropost" do
        lambda do
          visit root_path
          fill_in :micropost_title, :with => "Post 1"
          fill_in :micropost_content, :with => "eawfa ae wf"
          click_button
        end.should change(Micropost, :count).by(1)
      end


    end

  end



end
