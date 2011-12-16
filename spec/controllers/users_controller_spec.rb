require 'spec_helper'

describe UsersController do
  render_views

  #<Test for showing user
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

    #<Test for showing user's microposts
    it "should show microposts" do
      @user_1 = Factory(:user, :email => "eawfe@geaw.com")
      @mp1 = Factory(:micropost, :user => @user_1, :content => "This is post 1", 
                     :title => "Post 1")
      @mp2 = Factory(:micropost, :user => @user_1, :content => "This is post 2",
                     :title => "Post 2")
      get :show, :id => @user_1
      response.should have_selector("span.content", :content => @mp1.content)
      response.should have_selector("span.content", :content => @mp2.content)

    end
    #Test for showing user's microposts>


  end
  #Test for showing user>

  # <Test for new user page 
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have title 'Sign Up'" do 
      get 'new'
      response.should have_selector 'title', :content => "Sign Up"
    end

    #signed in ones
    it "should not let signed_in ones do it" do
      @user = Factory(:user)
      test_sign_in(@user)
      get 'new'
      response.should redirect_to(root_path)
    end
    
  end
  # Test for new user page>

  #<Test for create new user
  describe "POST 'create'" do

    #Not allowed to create using invalid information
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

    #Have to create using valid information
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

      it "should let user sign in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
      
      it "should not let signed_in ones do it" do
        @user = Factory(:user)
        test_sign_in(@user)
        post :create, :user =>@attr
        response.should redirect_to(root_path)
      end
   end
  end
  #Test for create new user>

  #<Test for editing page
  describe "GET 'edit'" do
    before(:each) do 
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title",:content => "Edit")
    end
    
  end
  #Test for editing page>

  #<Test for update user
  describe "PUT 'update'" do
    before(:each) do 
      @user = Factory(:user)
      test_sign_in(@user)
    end

    #Can not update using invalid information
    describe "failure" do
      
      before(:each) do
        @attr = {
                  :name => "",
                  :email => "", 
                  :password =>"",
          :password_confirmation => ""}
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end
      
      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title",:content => "Edit")
      end
       
    end
    
    #Have to be able to update using valid information
    describe "success" do

      before(:each) do
        @attr = {
                  :name => "Aaah Gi",
                  :email => "aaah.gi@name.com", 
                  :password =>"123qwert",
                  :password_confirmation => "123qwert"}
      end
      
      it "should change user information" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect to user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path)
      end

      it "should have a confirmation message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/i
      end
    end

  end
  #Test for update user>

  #<Test for authentication of edit/update page
  describe "authentication of edit/update page" do
    
    before(:each) do
      @user = Factory(:user)
    end

    #can not let non-signed-in user edit/update
    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        get :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end

    #have to only let correct sign-in user edit/update" 
    describe "for signed-in users" do
      before(:each) do
        # I do not quite understand why this will prevent signing
        # from happening.
        wrong_user = Factory(:user, :email => "user@exmaple.net")
        test_sign_in(wrong_user)
      end

      it "should require matcing user to sign in" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching user to update" do
        get :edit, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end
  #Test for authentication of edit/update page>

  #<Test for index action
  describe "GET 'index'" do

    # <Not signed in users test
    describe "Not signed-in users" do
      it "should be directed to root path" do
        get :index
        response.should redirect_to(signin_path)
        #flash variable is available for spec testing!
        flash[:notice].should =~ /sign in/i
      end
    end
    # Not signed in users test>
    
    # <Signed in users test
    describe "sign-in users" do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
        second_user = Factory(:user, :email => "123weaf@mymail.com")
        third_user = Factory(:user, :email => "123leaf@mymail.com")
        @users = [@user,second_user,third_user]
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should show a user page" do
        get :index
        response.should have_selector("h1", :content => "Total")
      end

      it "should have an element for each user" do
        get :index
        @users.each do |user|
        response.should have_selector("li",:content => @user.name)
        end
      end

    end
    #Not signed in users test>

  end
  #Test for index action>


  #<Test for destroy action inside user controller
  describe "DELETE 'destroy'" do
    before(:each) do 
      @user = Factory(:user)
    end

    describe "non-signed in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
      
    describe "signed in but non admin" do
      it "should deny access" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end

    describe "signed in as admin" do
        
      before(:each) do
        #admin is not accessible from application code
        #but spec test is not bound by that
        @admin = Factory(:user, :email => "admin@mymail.com", :admin => true)
        test_sign_in(@admin)
      end

      it "should destroy the user" do
        lambda do
        delete :destroy, :id => @user 
        end.should change(User, :count).by(-1)
      end
        
      it "should direct to user page afterwards" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end

      #admin can not delete itself
      it "should direct to user page afterwards" do
        delete :destroy, :id => @admin
        response.should redirect_to(root_path)
      end
    end
  end
  #Test for destroy action insider user controller>
  
end
