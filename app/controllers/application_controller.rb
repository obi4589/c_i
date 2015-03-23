class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include PasswordResetsHelper

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    sign_out   # Example method that will destroy the user cookies
	flash[:success] = "Please sign in again"
	redirect_to root_url
  end

end
