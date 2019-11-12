require 'rails_helper'

RSpec.describe "Login", type: :request do
  before(:each) do
    @user = User.new({ email: 'user@domain.com', password: 'my-secret' })
    @user.save!
    get new_login_path
  end

  context 'happy path' do
    before(:each) { post login_path, params: { user: { email: 'user@domain.com', password: 'my-secret' } } }

    it 'successful logins' do
      expect(response).to have_http_status(302)
      follow_redirect!
      expect(response.body).to include('Successfully logged in.')
    end

    it 'store user id in session' do
      expect(session[:user_id]).to eq(@user.id)
    end

    it 'logs user out' do
      follow_redirect!
      delete login_path
      follow_redirect!
      expect(response.body).to include('Successfully logged out.')
      expect(session[:user_id]).to be_nil
    end
  end

  context 'logins errors' do
    it 'bad email' do
      post login_path, params: { user: { email: 'nouser@domain.com', password: 'my-secret' } }
      expect(response.body).to include('Invalid logins email.')
    end

    it 'bad password' do
      post login_path, params: { user: { email: 'user@domain.com', password: 'bad-secret' } }
      expect(response.body).to include('Invalid password.')
    end
  end
end
