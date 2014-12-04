module PasswordResetsHelper

  def send_password_reset(user)
  	password_reset_token = User.new_remember_token #User.new_remember_token just generates a "SecureRandom.urlsafe_base64" number, so i simply reused that utility function instead of creating a new User.new_password_reset_token
  	user.update_attribute(:password_reset_token, User.digest(password_reset_token))
  	password_reset_sent_at = Time.now
  	user.update_attribute(:password_reset_sent_at, password_reset_sent_at)
  	UserMailer.password_reset(user).deliver
  end

end
