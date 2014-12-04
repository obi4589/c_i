class PasswordResetsController < ApplicationController
  
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
    if @user.password_reset_sent_at < 2.hours.ago
      flash[:error2] = "Password reset has expired"
      redirect_to reset_path
    elsif @user.update_attributes(user_params)
      flash[:success] = "Password has been reset"
      redirect_to root_url
    else
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

  layout false
end
