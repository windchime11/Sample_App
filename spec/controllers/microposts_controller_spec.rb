require 'spec_helper'

describe MicropostsController do
  render_views
  
  describe "access control" do
    
    it "should deny access to 'create' without signed in" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end


  describe "Post 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end
    
    describe "failure" do
      
      @attr = {:title => "", :content => ""}
      
      it "should have a non blank title or content" do
        lambda do 
          post :create, :micropost => @attr
        end.should_not change(Micropost,:count)
      end

      it "should render the home page" do
        post :create, :micropost => @attr
        response.should redirect_to(root_path)
      end

    end
    #the end above ends failure description
    
    describe "success" do
      before(:each) do
        @attr = {:title => "wahaha", :content => "every one smiles broadly"}
      end
      
      it "should create micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
        #post :create, :micropost => @attr
        #flash[:success].should =~ /created/i
      end

      it "should render the user show page" do
        post :create, :micropost => @attr
        response.should redirect_to(user_path(:id =>@user.id))
      end
      
      it "should have a flash message" do
        post :create, :micropost => @attr
        flash[:success].should =~ /created/i
      end

    end
 
   end
   #the end above ends "Post 'create'"

   #<destroy action for micropost
   describe "DELETE 'destroy'" do

     before(:each) do
      @user = Factory(:user)
      @mp = @user.microposts.create!(:title => "abc", :content => "eawfew")
     end

     it "non signed in user can not delete" do
      delete :destroy, :id => @mp
      #The reason it goes to signin_path is because :authenticate methd
      #was executed first and redirected to signin_path
      response.should redirect_to(signin_path)
     end

     it "signed in user can delete his/her own post" do
      lambda do
      test_sign_in(@user)
      delete :destroy, :id => @mp
      end.should change(Micropost,:count).by(-1)
     end

    it "signed in user can not delete other user's micropost" do
      @another_user = Factory(:user, :email => Factory.next(:email))
      test_sign_in(@another_user)
      delete :destroy, :id => @mp
      response.should redirect_to(root_path)
    end

   end
   #destroy action for micropost>
  
end
