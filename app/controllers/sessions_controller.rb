class SessionsController < ApplicationController
  before_action :logged_in, only: [:new]

  def new

  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
    	
      if params[:session][:remember_me] == '1'
        sign_in user
      else
        sign_in2 user
      end
      

      if is_charity?
    	  redirect_back_or home_charity_path(user)
      elsif is_philanthropist?
        redirect_back_or home_philanthropist_path(user)
      else
        redirect_back_or user
      end

  	else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end



  private

    def logged_in
      if signed_in?
        redirect_to(home_philanthropist_path(current_user)) if current_user.type == 'Philanthropist'
        redirect_to(home_charity_path(current_user)) if current_user.type == 'Charity'
        redirect_to(current_user) if current_user.type == 'Superadmin'
      end        
    end

  layout false
end