class Admin::FaqsController < ApplicationController
  include Skipable
  before_action :set_skip_title_and_meta_description
  before_action :set_faq_category
  before_action :set_faq, only: [ :edit, :update, :destroy, :move_up, :move_down ]
  before_action :verify_logged_in
  before_action :do_authorization

  def new
    @faq = Faq.new({ faq_category_id: @faq_category.id })
  end

  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      redirect_to [ :admin, @faq_category ], notice: 'New FAQ successfully created.'
      #redirect_to admin_faq_category_path(params[:faq_category_id]), notice: 'New FAQ successfully created.'
    else
      flash[:alert] = @faq.errors.full_messages.join('<br />')
      render action: :new
    end
  end

  def edit
  end

  def update
    if @faq.update(faq_params)
      redirect_to [ :admin, @faq_category ], notice: 'FAQ successfully updated.'
    else
      flash[:alert] = @faq.errors.full_messages.join('<br /')
      render action: :edit
    end
  end

  def destroy
    @faq.destroy
    redirect_to [ :admin, @faq_category ]
  end

  def move_up
    @faq.update(list_order_position: :up)
    redirect_to [ :admin, @faq_category ]
  end

  def move_down
    @faq.update(list_order_position: :down)
    redirect_to [ :admin, @faq_category ]
  end

  private

  def set_faq_category
    @faq_category = FaqCategory.find(params[:faq_category_id])
  end

  def set_faq
    @faq = Faq.find(params[:id])
  end

  def faq_params
    params.require(:faq).permit(:question, :answer, :faq_category_id)
  end

  def do_authorization
    authorize(Faq)
  end
end
