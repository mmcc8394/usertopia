class UsersController < ApplicationController
  before_action :authorize

  def index
    @users = policy_scope(User)
  end

  def show
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
