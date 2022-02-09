class Admin::PostsController < ApplicationController
  include Skipable
  before_action :set_skip_title_and_meta_description
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]
  before_action :verify_logged_in
  before_action :do_authorization

  def index
    @posts = policy_scope(Post)
  end

  def new
    @post = Post.new({ species: 'web_page' })
  end

  def create
    @post = Post.new(user_params.merge(published_by: @current_user.id))
    if @post.save
      @post.publish if publish?
      redirect_to [ :admin, @post ], notice: "New #{@post.species.humanize.downcase} successfully created."
    else
      flash[:alert] = @post.errors.full_messages.join('<br />')
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(user_params)
      @post.publish if publish?
      redirect_to [ :admin, @post ], notice: "New #{@post.species.humanize.downcase} successfully updated."
    else
      flash[:alert] = @post.errors.full_messages.join('<br />')
      render action: :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, notice: "#{@post.species.humanize} deleted."
  end

  private

  def publish?
    params[:commit] == 'publish'
  end

  def do_authorization
    authorize(Post)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def user_params
    params.require(:post).permit(:title, :species, :url, :meta_description, :content)
  end
end
