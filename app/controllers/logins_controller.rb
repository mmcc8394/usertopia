class LoginsController < ApplicationController
  def new
    redirect_to root_path, alert: "Youre already logged in, silly." if logged_in?
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    if @user
      if @user.authenticate(params[:user][:password])
        session[:user_id] = @user.id
        redirect_to root_path, notice: 'Successfully logged in.'
      else
        flash[:alert] = 'Invalid password.'
        render :new
      end
    else
      flash[:alert] = 'Invalid logins email.'
      @user = User.new
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Successfully logged out.'
  end
end
