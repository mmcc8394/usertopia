require 'rails_helper'

RSpec.describe FaqCategory, type: :model do
  before(:each) { @faq_category = FaqCategory.new({title: 'Some Category' }) }

  context 'valid' do
    it 'create' do
      expect(@faq_category.save).to be(true)
    end

    it 'adds list order' do
      @faq_category.save!
      expect(@faq_category.list_order).to_not be_nil
    end
  end

  context 'invalid' do
    it 'title is nil' do
      @faq_category.title = nil
      expect(@faq_category.valid?).to eq(false)
      expect(@faq_category.errors[:title]).to include("can't be blank")
    end

    it 'title is blank' do
      @faq_category.title = ''
      expect(@faq_category.valid?).to eq(false)
      expect(@faq_category.errors[:title]).to include("can't be blank")
    end

    it 'title is not unique' do
      @faq_category.save!
      cat_2 = FaqCategory.new({ title: 'Some Category' })
      expect(cat_2.valid?).to eq(false)
      expect(cat_2.errors[:title]).to include('has already been taken')
    end
  end

  context 'list ordering' do
    before(:each) do
      @faq_category.save!
      @cat_2 = FaqCategory.create!({ title: 'New Category' })
    end

    # assumes a second added item comes after first created
    it 'adds after first' do
      expect(@faq_category.list_order).to be < @cat_2.list_order
    end

    it 'move cat_2 to front' do
      @cat_2.update(list_order_position: :first)
      expect(@faq_category.list_order).to be > @cat_2.list_order
    end
  end

  context 'association with Faq model' do
    before(:each) do
      @faq_category.save!
      @faq_1 = Faq.create!({faq_category_id: @faq_category.id, question: 'Question?', answer: 'Answer.' })
      @faq_2 = Faq.create!({faq_category_id: @faq_category.id, question: 'Another question?', answer: 'Another answer.' })
    end

    it 'present' do
      expect(FaqCategory.find(@faq_category.id).faqs.length).to eq(2)
    end

    it 'shows proper ordering of faqs' do
      expect(@faq_category.faqs.first.id).to eq(@faq_1.id)
      @faq_1.update(list_order_position: :last)
      @faq_category.reload
      expect(@faq_category.faqs.first.id).to eq(@faq_2.id)
    end

    it 'deletes all Faqs on destroy' do
      expect { @faq_category.destroy }.to change(Faq, :count).by(-2)
    end
  end
end
