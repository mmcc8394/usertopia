class UsersController < ApplicationController
  before_action :logged_in?

  def index
    @users = policy_scope(User)
  end

  def show
    @user = User.find(params[:id])
    authorize(@user)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
