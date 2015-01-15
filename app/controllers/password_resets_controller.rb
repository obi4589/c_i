class PasswordResetsController < ApplicationController
  before_action :logged_in, only: [:new]
  
  def new
  end


  def create
  	user = User.find_by(email: params[:password_reset][:email])
  	if user
  		send_password_reset(user)
  		flash[:success] = "Check your email"
  		redirect_to root_url
  	else
  		flash.now[:error] = 'Email does not exist' 
      render 'new'
  	end
  end


  def edit
    @user = User.find_by(password_reset_token: params[:id])
  end


  def update
    @user = User.find_by(password_reset_token: params[:id])
    proper_params
    if params[:user][:password].present? 
      if @user.password_reset_sent_at < 2.hours.ago
        flash[:error2] = "Password reset has expired"
        redirect_to reset_path
      elsif @user.update_attributes(user_params)
        flash[:success] = "Password has been reset"
        redirect_to root_url
      else
        render 'edit'
      end
    else
      flash.now[:error3] = "Please enter password"
      render 'edit'
    end
  end


  private
    def user_params
      if @user.type == "Philanthropist"
        params.require(:philanthropist).permit(:password, :password_confirmation )
      elsif @user.type == "Charity"
        params.require(:charity).permit(:password, :password_confirmation )
      else
        params.require(:superadmin).permit(:password, :password_confirmation )
      end
    end


    def proper_params
      if @user.type == "Philanthropist"
        params[:user] = params[:philanthropist]
      elsif @user.type == "Charity"
        params[:user] = params[:charity]
      else
        params[:user] = params[:superadmin]
      end
    end

    def logged_in
      if signed_in?
        redirect_to(home_philanthropist_path(current_user)) if current_user.type == 'Philanthropist'
        redirect_to(home_charity_path(current_user)) if current_user.type == 'Charity'
        redirect_to(current_user) if current_user.type == 'Superadmin'
      end        
    end



  layout false
end
