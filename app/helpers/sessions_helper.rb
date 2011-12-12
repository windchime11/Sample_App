module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  #this is purely for Rspec test
  def signed_in?
    !current_user.nil?
  end

  #Listing 10.12
  def deny_access
    store_location
    flash[:notice] = "Please Sign in to access the page"
    redirect_to signin_path 
  end

  #Listing 10.17
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  #10.15
  def current_user?(user)
    user == current_user
  end

  private 

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] ||[nil, nil]
    end
  
    def store_location
      session[:return_to] = request.fullpath
    end

end
