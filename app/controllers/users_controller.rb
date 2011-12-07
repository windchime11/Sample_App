class UsersController < ApplicationController
  def new
    @user = User.new
    @title = "Sign Up"
  end

  def show 
    @user = User.find(params[:id])
    @title = @user.name
  end

  def index
    @user_all = User.all
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to Zhuzhu Test Website!"
      sign_in @user
      redirect_to @user
    else
      @user.password = ""
      @user.password_confirmation = ""
      @title = "Sign Up Again"
      render 'new'
    end
  end

end
