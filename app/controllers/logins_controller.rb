class LoginsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:login][:email])
    if user
      if user.authenticate(params[:login][:password])
        session[:user_id] = user.id
        redirect_to root_path, notice: 'Successfully logged in.'
      else
        flash[:alert] = 'Invalid password.'
        render :new
      end
    else
      flash[:alert] = 'Invalid logins email.'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Successfully logged out.'
  end
end
