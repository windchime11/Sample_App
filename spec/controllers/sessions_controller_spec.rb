require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign In")
    end

  end

  describe "Post 'create'" do
    
    describe "failed signin" do
      
      before(:each) do
        @attr = {:email =>"donald.bean@example.com", :password => "invalid"}
      end

      it "should not authenticate" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title",:content => "Sign In")
      end

      it "should have a flash error message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end

    end

    describe "Successful signin" do
      
      before(:each) do
        @user = Factory(:user)
        @attr = {:email => @user.email, :password => @user.password}
      end

      it "should let user sign in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      it "should redirect to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end

    end

    describe "DELETE 'destroy'" do
      
      it "should sign user out" do
        test_sign_in(Factory(:user))
        delete :destroy
        controller.should_not be_signed_in
        response.should redirect_to(root_path)
      end
    end

  end

end
