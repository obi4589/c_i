class UserMailer < ActionMailer::Base
  default from: "noreply@cherryivy.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Cherry Ivy!')
  end

  def password_reset(user)
  	@user = user
  	mail(to: @user.email, subject: 'Password Reset')
  end

end
