class FaqCategory < ApplicationRecord
  include RankedModel
  ranks :list_order

  has_many :faqs, -> { order(:list_order) }, dependent: :destroy

  validates :title, presence: true
  validates :title, uniqueness: true
end
