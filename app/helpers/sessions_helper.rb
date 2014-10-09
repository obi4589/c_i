module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.current_user = user
  end

  #the method below gets called by the last line of the previous method
  def current_user=(user)
    @current_user = user
  end

  #this method ensures that current user is indeed defined
  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  #this method ensures that the user is equal to current user
  def current_user?(user)
    user == current_user
  end

# this method ensures that the current user is signed in
  def signed_in?
    !current_user.nil?
  end


#-----------SECTION FOR SIGNING OUT ----------
  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end


#-----------SECTION FOR DETERMINING IF CURRENT USER IS CHARITY OR PHILANTHROPIST OR SUPERADMIN
  def is_charity?
    current_user.type == "Charity"
  end

  def is_superadmin?
    current_user.type == "Superadmin"
  end







  #the two methods below are for friendly fowarding
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end



  #the method below is for friendly fowarding when javascript is involved, as in the SA index page (#already signed in)
  def keep_page
    session[:return_to] = request.referrer
  end


end