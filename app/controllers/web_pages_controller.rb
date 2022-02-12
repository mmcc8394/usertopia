class WebPagesController < ApplicationController
  def show
    @post = Post.find_by_url(params[:url])
    not_found unless @post.try(:published?)
  end
end