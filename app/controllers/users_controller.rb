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
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user), notice: 'New user created.'
    else
      render action: :new
    end
  end

  def edit
    @user = User.find(params[:id])
    authorize(@user)
  end

  def update
    @user = User.find(params[:id])
    authorize(@user)

    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'User info updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize(@user)
    @user.destroy
    redirect_to users_path, notice: 'User deleted.'
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
