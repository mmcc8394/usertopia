class UsersController < ApplicationController
  before_action :verify_logged_in

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
    @user = User.new(user_params_create)
    if @user.save
      redirect_to user_path(@user), notice: 'New user created.'
    else
      flash[:alert] = @user.errors.full_messages.join('<br />')
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

    if @user.update_non_password_attributes(user_params_update)
      redirect_to user_path(@user), notice: 'User info updated.'
    else
      flash[:alert] = @user.errors.full_messages.join('<br />')
      render action: :edit
    end
  end

  def edit_password
    @user = User.find(params[:id])
    authorize(@user)
  end

  def update_password
    @user = User.find(params[:id])
    authorize(@user)

    if @user.update(user_params_password_update)
      redirect_to user_path(@user), notice: 'User password changed.'
    else
      flash[:alert] = @user.errors.full_messages.join('<br />')
      render action: :edit_password
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize(@user)
    @user.destroy
    redirect_to users_path, notice: 'User deleted.'
  end

  private

  def user_params_create
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_params_update
    params.require(:user).permit(:email)
  end

  def user_params_password_update
    params.require(:user).permit(:password, :password_confirmation)
  end
end
