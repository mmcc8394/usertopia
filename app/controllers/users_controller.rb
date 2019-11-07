class UsersController < ApplicationController
  before_action :logged_in?

  def index
    authorize User
    @users = User.all
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
