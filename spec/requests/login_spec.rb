require 'rails_helper'

RSpec.describe "Login", type: :request do
  before(:each) do
    @user = User.new({ email: 'user@domain.com', password: 'my-secret' })
    @user.save!
    get login_new_path
  end

  context 'happy path' do
    before(:each) { post login_create_path, params: { login: { email: 'user@domain.com', password: 'my-secret' } } }

    it 'successful login' do
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include('Successfully logged in.')
    end

    it 'store user id in session' do
      expect(session[:user_id]).to eq(@user.id)
    end

    it 'logs user out' do
      follow_redirect!
      delete login_destroy_path
      follow_redirect!
      expect(response.body).to include('Successfully logged out.')
      expect(session[:user_id]).to be_nil
    end
  end

  context 'login errors' do
    it 'bad email' do
      post login_create_path, params: { login: { email: 'nouser@domain.com', password: 'my-secret' } }
      expect(response.body).to include('Invalid login email.')
    end

    it 'bad password' do
      post login_create_path, params: { login: { email: 'user@domain.com', password: 'bad-secret' } }
      expect(response.body).to include('Invalid password.')
    end
  end
end
