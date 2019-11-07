require 'rails_helper'

RSpec.describe "Users", type: :request do
  before(:each) do
    @admin = User.create!({ email: 'admin@domain.com', password: 'admin-secret', role: 'admin' })
    @user = User.create!({ email: 'basic@domain.com', password: 'user-secret' })
  end

  context 'list users' do
    it 'admin' do
      post login_path, params: { login: { email: 'admin@domain.com', password: 'admin-secret' } }
      get users_path
      expect(response.body).to include('admin@domain.com')
      expect(response.body).to include('basic@domain.com')
    end

    it 'fail if not logged in' do
      get users_path
      follow_redirect!
      expect(response.body).to include('Access denied. You must login as an authorized user.')
    end

    it 'fail if not admin' do
      post login_path, params: { login: { email: 'basic@domain.com', password: 'user-secret' } }
      get users_path
      follow_redirect!
      expect(response.body).to include('Access denied. You must login as an authorized user.')
    end
  end
end
