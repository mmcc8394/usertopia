class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  helper_method :current_user
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    user_not_authorized if current_user.nil?
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = 'Access denied. You must login as an authorized user.'
    redirect_to new_login_path
  end
end