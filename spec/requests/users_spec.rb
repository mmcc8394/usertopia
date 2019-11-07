require 'rails_helper'

RSpec.describe "Users", type: :request do
  before(:each) do
    @admin_password = 'admin-secret'
    @admin = User.create!({ email: 'admin@domain.com', password: @admin_password, role: 'admin' })

    @basic_password = 'basic-secret'
    @basic = User.create!({ email: 'basic@domain.com', password: @basic_password })
  end

  context 'list users' do
    it 'admin' do
      admin_login
      get users_path
      expect(response.body).to include(@admin.email)
      expect(response.body).to include(@basic.email)
    end

    it 'fail if not logged in' do
      get users_path
      expect_access_denied
    end

    it 'fail if not admin' do
      basic_login
      get users_path
      expect_access_denied
    end
  end

  context 'display a specific user' do
    it 'basic user can see themselves' do
      basic_login
      get user_path(@basic)
      expect_user_shown(@basic)
    end

    it 'basic user cannot see anyone else' do
      basic_login
      get user_path(@admin)
      expect_access_denied
    end

    it 'admin can see themselves' do
      admin_login
      get user_path(@admin)
      expect_user_shown(@admin)
    end

    it 'admin can see other users' do
      admin_login
      get user_path(@basic)
      expect_user_shown(@basic)
    end
  end

  #
  # TODO: Most of these should probably all be in a helper file somewhere.
  #

  def admin_login
    post login_path, params: { login: { email: @admin.email, password: @admin_password } }
  end

  def basic_login
    post login_path, params: { login: { email: @basic.email, password: @basic_password } }
  end

  def expect_access_denied
    expect(response).to have_http_status(302)
    follow_redirect!
    expect(response.body).to include('Access denied. You must login as an authorized user.')
  end

  def expect_user_shown(user)
    expect(response.body).to include('User Details')
    expect(response.body).to include(user.email)
  end
end
