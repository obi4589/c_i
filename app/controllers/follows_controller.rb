class FollowsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user_type

  def create
    @user = User.find(params[:follow][:followable_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.js
    end    
  end

  def destroy
    @user = Follow.find(params[:id]).followable
    current_user.stop_following(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer }
      format.js
    end    
  end



  private


  # Before filters


      def signed_in_user
        unless signed_in?
          store_location
          redirect_to login_url, notice: "Please sign in."
        end
      end


      def correct_user_type
        redirect_to(current_user) unless current_user.type == 'Philanthropist' || current_user.type == 'Charity'
      end
end