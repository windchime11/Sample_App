class RelationshipsController < ApplicationController

  before_filter :authenticate

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
       format.html {redirect_to @user}
       format.js
    end
  
  end

  def destroy
    #tried session[:return_to] = request.fullpath
    #      redirect_to(session[:return_to])
    #It does not work!
    #Code to find @user is different in destroy from in create
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
        format.html {redirect_to @user}
        format.js
    end
    
  end

  
end
