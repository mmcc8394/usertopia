require 'rails_helper'
require 'helpers/users_helper'

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe "UsersBasic", type: :request do
  let(:valid_create_params) {
    { first_name: 'Jane', last_name: 'Doe', email: 'new-email@domain.com', password: 'new-secret', roles: [ 'basic' ] }
  }

  let(:valid_update_params) { { email: 'updated-email@domain.com' } }
  let(:valid_change_password) { { password: 'new-secret', password_confirmation: 'new-secret' } }

  before(:each) do
    create_basic_user
    basic_login
  end

  context 'can' do
    it 'show themselves' do
      get admin_user_path(@basic)
      expect_user_shown(@basic)
    end

    it 'edit non-role user data' do
      valid_user_edit(@basic)
    end

    it 'change their password' do
      valid_user_password_change(@basic)
    end
  end

  context 'cannot' do
    before(:each) { create_admin_user }
    after(:each) { expect_access_denied }

    it 'index' do
      get admin_users_path
    end

    it 'show another user' do
      get admin_user_path(@admin)
    end

    it 'new' do
      get new_admin_user_path
    end

    it 'create' do
      post admin_users_path, params: { user: valid_create_params }
    end

    it 'edit another user' do
      get edit_admin_user_path(@admin)
    end

    it 'update another user' do
      put admin_user_path(@admin), params: { user: valid_update_params }
    end

    it 'edit another user password' do
      get edit_password_admin_user_path(@admin)
    end

    it 'update another user password' do
      put update_password_admin_user_path(@admin), params: { user: valid_change_password }
    end

    it 'destroy' do
      delete admin_user_path(@basic)
    end

    it 'edit its own role(s)' do
      put admin_user_path(@basic), params: { user: { roles: [ 'admin' ] } }
    end
  end
end