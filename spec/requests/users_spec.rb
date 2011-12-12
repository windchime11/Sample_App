require 'spec_helper'

describe "Users" do
  describe "GET /users" do


    describe "Sign Up" do

      describe "failure" do
        
        it "should not make a new user" do
     
          lambda do
            visit signup_path
            fill_in "Name",             :with => ""
            fill_in "Email",             :with => ""
            fill_in "Password",             :with => ""
            fill_in "Confirmation",             :with => ""
            click_button
            response.should render_template('users/new')
            response.should have_selector("div#error_explanation")
          end.should_not change(User,:count)
        end
      end

      describe "success" do
        
        it "should make a new user" do
     
          lambda do
            visit signup_path
            fill_in "Name",             :with => "Foo Bar"
            fill_in "Email",             :with => "Foo.bar@foobar.com"
            fill_in "Password",             :with => "12Xefwefa"
            fill_in "Confirmation",             :with => "12Xefwefa"
            click_button
            response.should render_template('users/show')
            response.should have_selector("div.flash.success",:content=> "Welcome")
          end.should change(User,:count).by(1)
        end
      end

    end

    describe "Sign In/Out" do
      describe "failure" do
        it "should not sign a user in" do
          visit signin_path
          fill_in :email, :with => ""
          fill_in :password, :with => ""
          click_button
          response.should have_selector("div.flash.error",:content => "Invalid")
        end
        
      end

      describe "success" do
        it "should let user sign in and out " do
        @user = Factory(:user)
        visit signin_path
          fill_in :email, :with => @user.email
          fill_in :password, :with => @user.password
          click_button
          controller.should be_signed_in
          click_link "Sign Out"
          controller.should_not be_signed_in
       end
      end
    end



  end
end
