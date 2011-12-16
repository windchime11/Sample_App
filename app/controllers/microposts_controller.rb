class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_author, :only =>[:destroy]

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to user_path(:id => current_user.id)
    else
      flash[:error] = "Unable to create micropost. Please check again"
      redirect_to root_path
    end
  end
    
  def destroy
    @micropost.destroy
    redirect_to root_path
  end

  private 
     def authorized_author
       @micropost = Micropost.find(params[:id])
       #There is no chance that current_user will be nil as authenticate
       #method stopped that from reaching this line of code.
       redirect_to root_path unless (current_user == @micropost.user ||
                                     current_user.admin?)
     end

end
