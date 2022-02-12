class BlogsController < ApplicationController
  def index
    @posts = Post.live_blog_posts
  end

  def show
    @post = Post.find_by_url(params[:url])
    @no_tagline_logo = @post.try(:introducing_techunwreck?)
    not_found unless @post.try(:published?)
  end
end