class Admin::UsersController < ApplicationController
  include Skipable
  before_action :set_skip_title_and_meta_description
  before_action :filter_array_of_empty_strings, only: [ :create, :update ]
  before_action :set_user, only: [ :show, :edit, :update, :edit_password, :update_password, :destroy ]
  before_action :verify_logged_in
  before_action :authorize_any_user, only: [ :index, :new, :create ]
  before_action :authorize_specific_user, only: [ :show, :edit, :edit_password, :update_password, :destroy ]

  def index
    @users = User.active
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params_create)
    if @user.save
      redirect_to admin_users_path, notice: 'New user created.'
    else
      flash[:alert] = @user.errors.full_messages.join('<br />')
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def update
    # Must do this before authorize or UserPolicy:updating_roles? always return true.
    @user.assign_attributes(user_params_update)
    authorize(@user)

    if @user.save
      redirect_to admin_user_path(@user), notice: 'User info updated.'
    else
      flash[:alert] = @user.errors.full_messages.join('<br />')
      render action: :edit
    end
  end

  def edit_password
  end

  def update_password
    if @user.update(user_params_password_update)
      redirect_to admin_user_path(@user), notice: 'User password changed.'
    else
      flash[:alert] = @user.errors.full_messages.join('<br />')
      render action: :edit_password
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User deleted.'
  end

  private

  def filter_array_of_empty_strings
    return unless params && params[:user] && params[:user][:roles]
    params[:user][:roles].filter! { |role| role.present? }
  end

  def authorize_any_user
    authorize(User)
  end

  def authorize_specific_user
    authorize(@user)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params_create
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, roles: [])
  end

  def user_params_update
    params.require(:user).permit(:first_name, :last_name, :email, roles: [])
  end

  def user_params_password_update
    params.require(:user).permit(:password, :password_confirmation)
  end
end
