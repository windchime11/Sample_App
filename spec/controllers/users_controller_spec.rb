require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successfull" do 
      get :show, :id => @user
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do 
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should have the user name in header" do
      get :show, :id => @user
      response.should have_selector("h1",:content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      # The following test check if the CSS class of h1 img tag is gravatar.
      response.should have_selector("h1>img",:class => "gravatar")
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

  it "should have title 'Sign Up'" do 
    get 'new'
    response.should have_selector 'title', :content => "Sign Up"
  end

  end

  describe "CREATE 'new'" do

    describe "failure" do
      before(:each) do 
        @attr = {:name => "", :email => "", :password => "",
          :password_confirmation => ""}
      end

      it "should not allow invalid signup" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User,:count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title",:content => "Sign Up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

   describe "success" do
      before(:each) do
        @attr = {:name => "Donald Edenburg", 
                 :email => "don.edenburg@abccorp.com", 
                 :password => "foobar123",
                 :password_confirmation => "foobar123"}
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User,:count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user =>@attr
        flash[:success].should =~ /welcome/i
      end
   end
  end
end
