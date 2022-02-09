require 'rails_helper'

RSpec.describe "Faqs", type: :request do
  before(:each) do
    @faq_category = FaqCategory.create!({ title: 'Some Category' })
    @faq = Faq.create!({ faq_category_id: @faq_category.id, question: 'Q?', answer: 'A.' })
  end

  context 'not logged in' do
    it 'new' do
      get new_admin_faq_category_faq_path(@faq_category)
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'logged in' do
    before(:each) do
      user = User.new({ id: 1, first_name: 'Jane', last_name: 'Doe', email: 'basic@domain.com', password: 'abcd', roles: [ 'basic' ] })
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    let(:valid_attributes) { { faq_category_id: @faq_category.id, question: 'New Q?', answer: 'New A.' } }

    it 'new' do
      get new_admin_faq_category_faq_url(@faq_category)
      expect(response).to be_successful
    end

    it 'edit' do
      get edit_admin_faq_category_faq_url(@faq_category, @faq)
      expect(response).to be_successful
    end

    context 'valid parameters' do
      describe 'create' do
        it 'actually created the object' do
          expect {
            post admin_faq_category_faqs_url(@faq_category), params: { faq: valid_attributes }
          }.to change(Faq, :count).by(1)
        end

        it 'redirect to created object page' do
          post admin_faq_category_faqs_path(@faq_category), params: { faq: valid_attributes }
          expect(response).to redirect_to(admin_faq_category_url(@faq_category))
        end
      end

      describe 'update' do
        before(:each) { patch admin_faq_category_faq_url(@faq_category, @faq), params: { faq: valid_attributes } }

        it 'object changes' do
          @faq.reload
          expect(@faq.question).to eq('New Q?')
        end

        it 'redirects to the faq_category' do
          expect(response).to redirect_to(admin_faq_category_url(@faq_category))
        end
      end
    end

    context 'invalid parameters' do
      let(:invalid_attributes) { { question: '' } }

      describe 'create' do
        it 'nothing created' do
          expect {
            post admin_faq_category_faqs_url(@faq_category), params: { faq: invalid_attributes }
          }.to change(Faq, :count).by(0)
        end

        it 'successful response with no redirect' do
          post admin_faq_category_faqs_url(@faq_category), params: { faq: invalid_attributes }
          expect(response).to be_successful
        end
      end

      describe 'update' do
        before(:each) { patch admin_faq_category_faq_url(@faq_category, @faq), params: { faq: invalid_attributes } }

        it 'nothing changed' do
          @faq.reload
          expect(@faq.question).to eq('Q?')
        end

        it 'successful response with no redirect' do
          expect(response).to be_successful
        end
      end
    end

    describe 'destroy' do
      it 'actually deletes the category' do
        expect { delete admin_faq_category_faq_url(@faq_category, @faq) }.to change(Faq, :count).by(-1)
      end

      it 'redirect to faq_category' do
        delete admin_faq_category_faq_url(@faq_category, @faq)
        expect(response).to redirect_to(admin_faq_category_url(@faq_category))
      end
    end

    describe 'change list order' do
      before(:each) { @faq_2 = Faq.create!(valid_attributes) }
      after(:each) do
        @faq.reload
        @faq_2.reload
        expect(@faq.list_order).to be > @faq_2.list_order
      end

      it 'move up one' do
        get move_up_admin_faq_category_faq_path(@faq_category, @faq_2)
      end

      it 'move down one' do
        get move_down_admin_faq_category_faq_path(@faq_category, @faq)
      end
    end
  end
end
