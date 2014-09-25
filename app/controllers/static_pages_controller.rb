class StaticPagesController < ApplicationController
  def home
    render :layout => false
  end

  def about
    render :layout => false
  end

  def terms
    render :layout => false
  end

  def privacy
    render :layout => false
  end

  def help
    render :layout => false
  end

  def login
    render :layout => false
  end

  def signup1
    render :layout => false
  end

  def signup2
    render :layout => false
  end

  def reset
    render :layout => false
  end
end
