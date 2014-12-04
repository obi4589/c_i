class SessionsController < ApplicationController

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

  layout false
end