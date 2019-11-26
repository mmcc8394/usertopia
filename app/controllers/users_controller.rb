class UsersController < ApplicationController
  before_action :verify_logged_in
  before_action :filter_array_of_empty_strings, only: [ :create, :update ]

  def index
    authorize(User)
    @users = User.active
  end

  def show
    @user = User.find(params[:id])
    authorize(@user)
  end

  def new
    authorize(User)
    @user = User.new
  end

  def create
    authorize(User)
    @user = User.new(user_params_create)
    if @user.save
      redirect_to users_path, notice: 'New user created.'
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

    #
    # Need to set a user's new role(s) before calling authorize or the policy will always pass
    # because if the current_user is the same as @user at this point, then the user_policy function
    # updating_roles? will always pass.
    #
    set_roles_if_submitted
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

  def filter_array_of_empty_strings
    return unless params && params[:user] && params[:user][:roles]
    params[:user][:roles].filter! { |role| role.present? }
  end

  def user_params_create
    params.require(:user).permit(:email, :password, :password_confirmation, roles: [])
  end

  def user_params_update
    params.require(:user).permit(:email, roles: [])
  end

  def user_params_password_update
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_roles_if_submitted
    return if params[:user].try(:[], :roles).blank?
    @user.roles = params[:user][:roles]
  end
end
