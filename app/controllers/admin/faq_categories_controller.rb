class Admin::FaqCategoriesController < ApplicationController
  include Skipable
  before_action :set_skip_title_and_meta_description
  before_action :set_faq_category, only: [ :show, :edit, :update, :destroy, :move_up, :move_down ]
  before_action :verify_logged_in
  before_action :do_authorization

  def index
    @faq_categories = FaqCategory.rank(:list_order).all
  end

  def new
    @faq_category = FaqCategory.new
  end

  def create
    @faq_category = FaqCategory.new(faq_category_params)

    if @faq_category.save
      redirect_to [ :admin, @faq_category ], notice: 'FAQ category was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @faq_category.update(faq_category_params)
      redirect_to [ :admin, @faq_category ], notice: 'FAQ category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # TODO: Can't delete a category while it has faqs
    @faq_category.destroy
    redirect_to admin_faq_categories_url, notice: 'FAQ category was successfully destroyed.'
  end

  # higher priority
  def move_up
    @faq_category.update(list_order_position: :up)
    redirect_to admin_faq_categories_url
  end

  # lower priority
  def move_down
    @faq_category.update(list_order_position: :down)
    redirect_to admin_faq_categories_url
  end

  private

  def set_faq_category
    @faq_category = FaqCategory.find(params[:id])
  end

  def faq_category_params
    params.require(:faq_category).permit(:title, :list_order)
  end

  def do_authorization
    authorize(FaqCategory)
  end
end
