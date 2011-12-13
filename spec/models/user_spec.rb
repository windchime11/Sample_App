require 'spec_helper'

#Test for User model. Different from tests for User controller
#
describe User do

  #This is the overarching setting. @attr is defined to be a valid
  #user's attributes.
  before(:each) do
    @attr = {:name => "Example User", :email => "joo@yooo.com",
             :password => "XET23jew$", :password_confirmation => "XET23jew$"}
  end

  #Create 
  it "should create new instance given valid structure" do
    User.create!(@attr)
  end

  it "should have non blank name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should have non empty email" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

  it "name should be within 50 char long" do
    long_name = "a" * 51;
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should approve valid email address" do
    emails = ["abcedf@gmail.com", "ew_faf12@gwe12.org"]
    emails.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should not approve invalid email address" do
    emails = %w[abc123~@gmail.com, ewe$wefw2@we21.org]
    emails.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate emails up to case" do 
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should require a password" do
    User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid 
  end
  
  it "should require a matching password confirmation" do
    User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
  end

  it "should reject short passwords" do
    example_short_password = "a" * 5
    User.new(@attr.merge(:password => example_short_password, :password_confirmation => example_short_password)).should_not be_valid
  end  

  it "should reject long passwords" do
    example_long_password = "a" * 41
    User.new(@attr.merge(:password => example_long_password, :password_confirmation => example_long_password)).should_not be_valid
  end  

  #<Password Encrption
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      
      it "should be true if the passwords match" do
        @user.password_matches?(@attr[:password]).should be_true
      end

      it "should be false if the passwords do not match" do
        @user.password_matches?("weafw").should_not be_true
      end
    end

    describe "User.authenticate method" do
      
      it "should be true if all match" do 
        matching_user = User.authenticate(@attr[:email],@attr[:password])
        matching_user.should == @user
      end

      it "should be false if non email exists" do
        nonexistent_user = User.authenticate("wfeafe@fwefaw.com",@attr[:password])
        nonexistent_user.should be_nil
      end

      it "should be false if password does not match" do
        wrong_pw_user = User.authenticate(@attr[:email],"wfefaefw")
        wrong_pw_user.should be_nil
      end

    end
  end
  #Password encryption>

  #<Admin attribute
  describe "admin attributes" do

    before(:each) do
      @user = User.create(@attr)
    end

    it "should have admin attribute" do
      @user.should respond_to(:admin)
    end

    #this uses @user.admin? method
    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be able to be converted to admin" do
      #what is toggle???
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
  #Admin attribute>

  #<Microposts attributes
  describe "Micropost association" do
    before(:each) do
      @user = User.create!(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a microposts attributes" do
      @user.should respond_to(:microposts)
    end

    #Check both the order of posts and @user.microposts is an array of 
    #microposts
    it "should have microposts in right order" do
      @user.microposts.should == [@mp2, @mp1]
    end

  end
  #Microposts attributes>

  

end
