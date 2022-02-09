require 'rails_helper'

RSpec.describe "/faq_categories", type: :request do
  before(:each) { @faq_category = FaqCategory.create!({title: 'Some Category' }) }

  context 'not logged in' do
    it 'index' do
      get admin_faq_categories_url
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'logged in' do
    before(:each) do
      user = User.new({ id: 1, first_name: 'Jane', last_name: 'Doe', email: 'basic@domain.com', password: 'abcd', roles: [ 'basic' ] })
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it 'index' do
      get admin_faq_categories_url
      expect(response).to be_successful
    end

    it 'show' do
      get admin_faq_categories_url(@faq_category)
      expect(response).to be_successful
    end

    it 'new' do
      get new_admin_faq_category_url
      expect(response).to be_successful
    end

    it 'edit' do
      get edit_admin_faq_category_url(@faq_category)
      expect(response).to be_successful
    end

    context 'valid parameters' do
      let(:valid_attributes) { { title: 'Another Category' } }

      describe 'create' do
        it 'actually created the object' do
          expect {
            post admin_faq_categories_url, params: { faq_category: valid_attributes }
          }.to change(FaqCategory, :count).by(1)
        end

        it 'redirect to created object page' do
          post admin_faq_categories_url, params: { faq_category: valid_attributes }
          expect(response).to redirect_to(admin_faq_category_url(FaqCategory.last))
        end
      end

      describe 'update' do
        let(:new_attributes) { { title: 'Edited Category' } }

        it 'object changes' do
          patch admin_faq_category_url(@faq_category), params: { faq_category: new_attributes }
          @faq_category.reload
          expect(@faq_category.title).to eq('Edited Category')
        end

        it 'redirects to the faq_category' do
          patch admin_faq_category_url(@faq_category), params: { faq_category: new_attributes }
          expect(response).to redirect_to(admin_faq_category_url(@faq_category))
        end
      end
    end

    context 'invalid parameters' do
      let(:invalid_attributes) { { title: '' } }

      describe 'create' do
        it 'nothing created' do
          expect {
            post admin_faq_categories_url, params: { faq_category: invalid_attributes }
          }.to change(FaqCategory, :count).by(0)
        end

        it 'successful response with no redirect' do
          post admin_faq_categories_url, params: { faq_category: invalid_attributes }
          expect(response).to be_successful
        end
      end

      describe 'update' do
        it 'nothing changed' do
          patch admin_faq_category_url(@faq_category), params: {faq_category: invalid_attributes }
          @faq_category.reload
          expect(@faq_category.title).to eq('Some Category')
        end

        it 'successful response with no redirect' do
          patch admin_faq_category_url(@faq_category), params: {faq_category: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'destroy' do
      it 'actually deletes the category' do
        expect { delete admin_faq_category_url(@faq_category) }.to change(FaqCategory, :count).by(-1)
      end

      it 'redirect to faq_categories list' do
        delete admin_faq_category_url(@faq_category)
        expect(response).to redirect_to(admin_faq_categories_url)
      end
    end

    describe 'change list order' do
      before(:each) { @cat_2 = FaqCategory.create!({ title: 'New Category' }) }
      after(:each) do
        @faq_category.reload
        @cat_2.reload
        expect(@faq_category.list_order).to be > @cat_2.list_order
      end

      it 'move up one' do
        get move_up_admin_faq_category_path(@cat_2)
      end

      it 'move down one' do
        get move_down_admin_faq_category_path(@faq_category)
      end
    end
  end
end
