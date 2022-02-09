require 'rails_helper'

RSpec.describe Faq, type: :model do
  before(:each) do
    @faq_category = FaqCategory.create!({title: 'Some Category' })
    @faq = Faq.new({faq_category_id: @faq_category.id, question: 'Question?', answer: 'Answer.' })
  end

  context 'valid' do
    it 'create' do
      expect(@faq.save).to be(true)
    end

    it 'adds list order' do
      @faq.save!
      expect(@faq.list_order).to_not be_nil
    end
  end

  context 'invalid' do
    it 'question is nil' do
      @faq.question = nil
      expect(@faq.valid?).to eq(false)
      expect(@faq.errors[:question]).to include("can't be blank")
    end

    it 'question is blank' do
      @faq.question = ''
      expect(@faq.valid?).to eq(false)
      expect(@faq.errors[:question]).to include("can't be blank")
    end

    it 'answer is nil' do
      @faq.answer = nil
      expect(@faq.valid?).to eq(false)
      expect(@faq.errors[:answer]).to include("can't be blank")
    end

    it 'answer is blank' do
      @faq.answer = ''
      expect(@faq.valid?).to eq(false)
      expect(@faq.errors[:answer]).to include("can't be blank")
    end
  end

  context 'list ordering' do
    before(:each) do
      @faq.save!
      @faq_2 = Faq.create!({faq_category_id: @faq_category.id, question: 'Another question?', answer: 'Another answer.' })
    end

    # assumes a second added item comes after first created
    it 'adds after first' do
      expect(@faq.list_order).to be < @faq_2.list_order
    end

    it 'move cat_2 to front' do
      @faq_2.update(list_order_position: :first)
      expect(@faq.list_order).to be > @faq_2.list_order
    end
  end

  context 'association with FAQ category' do
    before(:each) { @faq.save! }

    it 'associated' do
      expect(Faq.find(@faq.id).faq_category.title).to eq(@faq_category.title)
    end

    it 'deleted after destroying parent' do
      expect { @faq_category.destroy }.to change(Faq, :count).by(-1)
    end
  end
end
