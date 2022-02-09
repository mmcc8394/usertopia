require 'rails_helper'
require 'helpers/users_helper'

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe "UsersNotLoggedIn", type: :request do
  context 'cannot' do
    before(:each) { create_basic_user }
    after(:each) { expect_access_denied }

    it 'index' do
      get admin_users_path
    end

    it 'new' do
      get new_admin_user_path
    end

    it 'create' do
      post admin_users_path, params: { user: { email: 'new-user@domain.com', password: 'new-secret', roles: [ 'basic' ] } }
    end

    it 'edit' do
      get edit_admin_user_path(@basic)
    end

    it 'update' do
      put admin_user_path(@basic), params: { user: { email: 'new-email@domain.com' } }
    end

    it 'show' do
      get admin_user_path(@basic)
    end

    it 'destroy' do
      delete admin_user_path(@basic)
    end
  end
end