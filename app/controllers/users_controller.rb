class UsersController < ApplicationController
  before_action :logged_in?

  def index
    authorize(User)
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    authorize(@user)
  end

  def new
    authorize(User)
  end

  def create
    authorize(User)
  end

  def edit
    @user = User.find(params[:id])
    authorize(@user)
  end

  def update
    @user = User.find(params[:id])
    authorize(@user)

    if @user.update(user_params)
      flash[:notice] = 'User info updated.'
      redirect_to user_path(@user)
    else
      render action: :edit
    end
  end

  def destroy
    authorize(User)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
