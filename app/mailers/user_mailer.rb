class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'New User Account Created')
  end

  def reset_password_link(user)
    @user = user
    mail(to: @user.email, subject: 'Password Reset Link')
  end
end
