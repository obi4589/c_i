class SessionsController < ApplicationController

  def new

  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
    	sign_in user

      if is_charity?
    	  redirect_back_or home_charity_path(user)
      elsif is_philanthropist?
        redirect_back_or home_philanthropist_path(user)
      else
        redirect_back_or user
      end

  	else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

  layout false
end