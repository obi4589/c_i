class PhilanthropistsController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :home, :followers, :following]
  before_action :correct_user,   only: [:edit, :update, :home]
  before_action :is_superadmin?, only: [:destroy]


  def index
    @users = User.all
  end


  def new
  	@philanthropist = Philanthropist.new
  end



  def create
    @philanthropist = Philanthropist.new(philanthropist_params)    
    if @philanthropist.save
        sign_in @philanthropist
        flash[:success] = "Welcome to Cherry Ivy"
        redirect_to home_philanthropist_path(@philanthropist)
    else
      render 'new'
    end    
  end




  def show
  	@philanthropist = Philanthropist.find(params[:id]) 
    @events = @philanthropist.events.all
    @user = @philanthropist
  end


  def edit
    @philanthropist = Philanthropist.find(params[:id])
  end


  def update
    @philanthropist = Philanthropist.find(params[:id])
    if @philanthropist.update_attributes(philanthropist_params)
      flash[:success] = "Profile updated"
      redirect_to @philanthropist
    else
      render 'edit'
    end
  end

  def destroy
    keep_page
    Philanthropist.find(params[:id]).destroy
    flash[:success] = "Philanthropist deleted."
    redirect_back_or index1_superadmin_path(current_user)
  end

  def home
    @philanthropist = Philanthropist.find(params[:id])
    @feed_items = current_user.feed.all
    render 'home'
  end

  def followers
    @philanthropist = Philanthropist.find(params[:id])
    @user = @philanthropist
    @followers = @user.followers
    render 'followers'
  end

  def following
    @philanthropist = Philanthropist.find(params[:id])
    @user = @philanthropist
    @following = @user.all_follows
    render 'following'
  end

  

  private
  	def philanthropist_params
  		params.require(:philanthropist).permit(:name, :email, :zip_code, :birth_date, :password, :password_confirmation )
  	end

    # Before filters


    def signed_in_user
      unless signed_in?
        store_location
        redirect_to login_url, notice: "Please sign in."
      end
    end

    def correct_user
      @philanthropist = Philanthropist.find(params[:id])
      redirect_to(@philanthropist) unless current_user?(@philanthropist)
    end






  layout false
end
