class CharitiesController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :home]
  before_action :correct_user,   only: [:edit, :update, :home]
  before_action :is_superadmin?, only: [:destroy]


  def index
    @users = User.all
  end



  def new
  	@charity = Charity.new
  end



  def create
    @charity = Charity.new(charity_params)   
    if @charity.save
        sign_in @charity
        flash[:success] = "Welcome to Cherry Ivy"
        redirect_to @charity
    else
      render 'new'
    end    
  end



  def show
  	@charity = Charity.find(params[:id]) 
    @events = @charity.events.all
  end


  def edit
    @charity = Charity.find(params[:id])
  end


  def update
    @charity = Charity.find(params[:id])
    if @charity.update_attributes(charity_params)
      flash[:success] = "Profile updated"
      redirect_to @charity
    else
      render 'edit'
    end
  end

  def destroy
    keep_page
    Charity.find(params[:id]).destroy
    flash[:success] = "Charity deleted."
    redirect_back_or index1_superadmin_path(current_user)
  end

  

  def home
    @charity = Charity.find(params[:id])
    @feed_items = current_user.feed.all
    render 'home'
  end





  private
  	def charity_params
  		params.require(:charity).permit(:legal_name, :name, :ein, :zip_code, :contact_person, :email, :phone, :password, :password_confirmation, :mission)
  	end


    # Before filters


    def signed_in_user
      unless signed_in?
        store_location
        redirect_to login_url, notice: "Please sign in."
      end
    end

    def correct_user
      @charity = Charity.find(params[:id])
      redirect_to(@charity) unless current_user?(@charity)
    end





  layout false
end
