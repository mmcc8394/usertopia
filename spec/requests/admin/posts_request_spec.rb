require 'rails_helper'
require 'helpers/users_helper'

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe "Posts", type: :request do
  let(:valid_create_params) { { title: 'Another Web Page', url: 'another-url', species: 'web_page', meta_description: 'blah blah', content: 'More blah blah.' } }
  let(:valid_update_params) { { title: 'New Web Page Title', url: 'new-page-url', species: 'web_page', meta_description: 'blah blah', content: 'More blah blah.'} }

  before(:each) {
    @user = User.create!({ first_name: 'John', last_name: 'Smith', email: 'admin@domain.com', password: 'abc123xyz', roles: [ 'basic' ] })
    @post = Post.create!({ title: 'Web Page', url: 'web-page-url', species: 'web_page',
                           meta_description: 'blah blah', content: 'More blah blah.',
                           published_by: @user.id })
  }

  context 'not logged in' do
    after(:each) { expect_access_denied }

    it 'index', focus: true do
      get admin_posts_path
      expect(response).to have_http_status(:forbidden)
    end

    it 'new' do
      get new_admin_post_path
    end

    it 'create' do
      post admin_posts_path, params: { post: valid_create_params.merge(published_by: @user.id) }
    end

    it 'show' do
      get admin_post_path(@post)
    end

    it 'edit' do
      get edit_admin_post_path(@post)
    end

    it 'update' do
      put admin_post_path(@post), params: { post: valid_update_params }
    end

    it 'destroy' do
      delete admin_post_path(@post)
    end
  end

  context 'logged in' do
    before(:each) do
      create_basic_user
      basic_login
    end

    after(:each) { expect(response).to have_http_status(200) }

    it 'index' do
      get admin_posts_path
    end

    it 'new' do
      get new_admin_post_path
    end

    it 'create' do
      post admin_posts_path, params: { post: valid_create_params.merge(published_by: @user.id) }
      verify_success_and_follow_with_text('New web page successfully created.')
    end

    it 'edit' do
      get edit_admin_post_path(@post)
    end

    it 'update' do
      put admin_post_path(@post, params: { post: valid_update_params })
      verify_success_and_follow_with_text('New web page successfully updated.')
    end

    it 'destroy' do
      delete admin_post_path(@post)
      verify_success_and_follow_with_text('Web page deleted.')
    end
  end

  context 'validate data' do
    before(:each) do
      create_basic_user
      basic_login
    end

    context 'valid' do
      it 'index' do
        get admin_posts_path
        expect(response.body).to include(@post.title)
      end

      it 'show' do
        get admin_post_path(@post)
        expect(response.body).to include(@post.title)
        expect(response.body).to include(@post.url)
        expect(response.body).to include(@post.content.to_s)
      end

      let(:valid_create_params) { { title: 'Another Web Page', url: 'another-url', species: 'web_page', meta_description: 'blah blah', content: 'More blah blah.' } }
      let(:valid_update_params) { { title: 'New Web Page Title', url: 'new-page-url', species: 'web_page', meta_description: 'blah blah', content: 'More blah blah.'} }

      it 'create' do
        post admin_posts_path, params: { post: valid_create_params.merge(published_by: @user.id) }
        verify_success_and_follow
        expect(Post.all.length).to eq(2)
        expect(response.body).to include(valid_create_params[:title])
        expect(response.body).to include(valid_create_params[:url])
        expect(response.body).to include(valid_create_params[:content])
      end

      it 'update' do
        put admin_post_path(@post), params: { post: valid_update_params }
        verify_success_and_follow
        expect(Post.all.length).to eq(1)
        expect(response.body).to include(valid_update_params[:title])
        expect(response.body).to include(valid_update_params[:url])
        expect(response.body).to include(valid_update_params[:content])
      end

      it 'destroy' do
        delete admin_post_path(@post)
        verify_success_and_follow
        expect(Post.all.length).to eq(0)
      end
    end
  end
end
