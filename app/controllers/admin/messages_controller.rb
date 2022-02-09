class Admin::MessagesController < ApplicationController
  include Skipable
  before_action :set_skip_title_and_meta_description
  before_action :verify_logged_in
  before_action :do_authorization

  def index
    @messages = policy_scope(Message).order('created_at desc')
  end

  private

  def do_authorization
    authorize(Post)
  end
end