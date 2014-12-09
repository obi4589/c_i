class PhilanthropistsController < ApplicationController
  before_action :signed_in_user, only: [:show, :edit, :update, :home, :followers, :following, :history]
  before_action :correct_user,   only: [:edit, :update, :home]
  before_action :is_superadmin?, only: [:destroy]


  def new
  	@philanthropist = Philanthropist.new
  end



  def create
    @philanthropist = Philanthropist.new(philanthropist_params)    
    if @philanthropist.save
        UserMailer.welcome_email(@philanthropist).deliver
        sign_in @philanthropist
        flash[:success] = "Welcome to Cherry Ivy"
        redirect_to suggestions_activities_path
        #redirect_to home_philanthropist_path(@philanthropist)
    else
      render 'new'
    end    
  end




  def show
  	@philanthropist = Philanthropist.find(params[:id]) 
    events = @philanthropist.events.all.sort_by {|x| [x.start_date, x.start_time, x.end_time] }
    @final_feed = events.select {|x| x.start_date >= Date.today }.take(100)
    @months = @final_feed.map {|x| x.start_date.strftime('%B %Y')}.uniq
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
    #@feed_items = current_user.feed.all
    feed1 = current_user.feed1.all
    feed2 = current_user.feed2.all
    total_feed = feed1 + feed2
    feed_items = total_feed.uniq.sort_by {|x| [x.start_date, x.start_time, x.end_time] }
    @final_feed = feed_items.select {|x| x.start_date >= Date.today }.take(100)
    @months = @final_feed.map {|x| x.start_date.strftime('%B %Y')}.uniq
  end

  def followers
    @philanthropist = Philanthropist.find(params[:id])
    @user = @philanthropist
    @followers = Follow.where(followable_id: @user.id).sort{ |a,b| b[:created_at] <=> a[:created_at] }
    #@followers = @user.followers.sort_by(&:name)
  end

  def following
    @philanthropist = Philanthropist.find(params[:id])
    @user = @philanthropist
    @following = @user.all_follows.sort{ |a,b| b[:created_at] <=> a[:created_at] }
  end


  def history
    @philanthropist = Philanthropist.find(params[:id]) 
    events = @philanthropist.events.all.sort {|x,y| [y.start_date, y.start_time, y.end_time] <=> [x.start_date, x.start_time, x.end_time] }
    @final_feed = events.select {|x| x.start_date < Date.today }.take(100)
    @months = @final_feed.map {|x| x.start_date.strftime('%B %Y')}.uniq
    @user = @philanthropist
  end


  def active
    @philanthropist = Philanthropist.find(params[:id])
    if @philanthropist.active_p? 
      @philanthropist.update_attribute(:active_p, false)
      redirect_to request.referrer 
    else
      @philanthropist.update_attribute(:active_p, true)
      UserMailer.active_email(@philanthropist).deliver
      redirect_to request.referrer 
    end
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
