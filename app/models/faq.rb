class Faq < ApplicationRecord
  include RankedModel
  ranks :list_order

  has_rich_text :answer
  belongs_to :faq_category

  validates :question, :answer, presence: true

  # TODO: This should probably be a flag in the database?
  def self.top_questions
    where('question in (?)', [ 'Where are you located?',
                               'How long do repairs take?',
                               'How much do repairs cost?',
                               'How much does shipping cost?',
                               'Why should I choose your service?' ])
  end
end
