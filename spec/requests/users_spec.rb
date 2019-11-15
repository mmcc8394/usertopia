require 'rails_helper'

RSpec.describe "Users", type: :request do
  before(:each) do
    @admin_password = 'admin-secret'
    @admin = User.create!({ email: 'admin@domain.com', password: @admin_password, role: 'admin' })

    @basic_password = 'basic-secret'
    @basic = User.create!({ email: 'basic@domain.com', password: @basic_password })
  end

  context 'admin can access everything' do
    before(:each) { admin_login }

    it 'index' do
      get users_path
      expect(response.body).to include(@admin.email)
      expect(response.body).to include(@basic.email)
    end

    it 'show another user' do
      get user_path(@basic)
      expect_user_shown(@basic)
    end

    it 'loads the new user page' do
      get new_user_path
      expect(response).to have_http_status(200)
    end

    it 'create a new user' do
      post users_path, params: { user: { email: 'new-email@domain.com', password: 'new-secret' } }
      verify_success_and_follow_with_text('New user created.')
      expect(User.all.order(:id).last.email).to eq('new-email@domain.com')
    end

    it 'loads the edit user page' do
      get edit_user_path(@admin)
      expect(response).to have_http_status(200)
    end

    it 'edit another user' do
      valid_user_edit(@basic)
    end

    it 'loads the edit password page' do
      get edit_password_user_path(@admin)
      expect(response).to have_http_status(200)
    end

    it 'change password' do
      valid_user_password_change(@admin)
    end

    it 'deletes a non-admin user' do
      delete user_path(@basic)
      verify_success_and_follow_with_text('User deleted.')
      expect(User.find_by_id(@basic.id)).to be_nil
    end

    it 'does not allow delete of admin user' do
      new_admin = User.create!({ email: 'new-admin@domain.com', password: 'some-secret', role: 'admin' })
      delete user_path(new_admin)
      expect_access_denied
    end
  end

  context 'editing user info and passwords' do
    before(:each) { admin_login }

    it 'ignore password updates in an edit' do
      put user_path(@admin), params: { user: { email: 'new-email@domain.com', password: 'ignore-password' } }
      verify_success_and_follow_with_text('User info updated.')
      expect(User.find_by_id(@admin.id).authenticate(@admin_password)).to be_truthy
    end

    it 'ignore user info update in password change' do
      put update_password_user_path(@admin), params: { user: { email: 'ignore-email@domain.com', password: 'ignore-password' } }
      verify_success_and_follow_with_text('User password changed.')
      expect(User.find_by_id(@admin.id).email).to_not eq('ignore-email@domain.com')
    end
  end

  context 'basic user can access a few things' do
    before(:each) { basic_login }

    it 'show themselves' do
      get user_path(@basic)
      expect_user_shown(@basic)
    end

    it 'edit their user data' do
      valid_user_edit(@basic)
    end

    it 'change their password' do
      valid_user_password_change(@basic)
    end
  end

  context 'authorized but invalid operations' do
    before(:each) { admin_login }

    it 'create with duplicate email' do
      post users_path, params: { user: { email: @basic.email, password: 'new-secret' } }
      expect(response.body).to include('Email has already been taken')
    end

    it 'create with invalid email' do
      post users_path, params: { user: { email: 'bad-format', password: 'new-secret' } }
      expect(response.body).to include('Email is invalid')
    end

    it 'create with email blank' do
      post users_path, params: { user: { email: '', password: 'new-secret' } }
      expect(response.body).to include("Email is invalid")
    end

    it 'create with email missing' do
      post users_path, params: { user: { password: 'new-secret' } }
      expect(response.body).to include("Email is invalid")
    end

    it 'create with confirmation emails not matching' do
      post users_path, params: { user: { email: 'some-email@domain.com', password: 'new-secret', password_confirmation: 'bad-secret' } }
      expect(response.body).to include("Password confirmation doesn't match")
    end

    it 'create with password too short' do
      post users_path, params: { user: { email: 'some-email@domain.com', password: 'pass' } }
      expect(response.body).to include('Password is too short')
    end

    it 'create with password blank' do
      post users_path, params: { user: { email: 'some-email@domain.com', password: '' } }
      expect(response.body).to include("Password can't be blank")
    end

    it 'create with password missing' do
      post users_path, params: { user: { email: 'some-email@domain.com' } }
      expect(response.body).to include("Password can't be blank")
    end
  end

  context 'basic user access denied' do
    before(:each) { basic_login }
    after(:each) { expect_access_denied }

    it 'index' do
      get users_path
    end

    it 'show another user' do
      get user_path(@admin)
    end

    it 'new' do
      get new_user_path
    end

    it 'create' do
      post users_path, params: { user: { email: 'junk@domain.com', password: 'some-secret' } }
    end

    it 'edit another user' do
      get edit_user_path(@admin)
    end

    it 'update another user' do
      put user_path(@admin), params: { user: { email: 'junk@domain.com' } }
    end

    it 'edt another user password' do
      get edit_password_user_path(@admin)
    end

    it 'update another user password' do
      put update_password_user_path(@admin), params: { user: { password: 'new-secret', password_confirmation: 'new-secret' } }
    end

    it 'destroy' do
      delete user_path(@basic)
    end
  end

  context 'no access if not logged in' do
    after(:each) { expect_access_denied }

    it 'index' do
      get users_path
    end

    it 'new' do
      get new_user_path
    end

    it 'create' do
      post users_path, params: { user: { email: @basic.email, password: @basic_password } }
    end

    it 'edit' do
      get edit_user_path(@basic)
    end

    it 'update' do
      put user_path(@basic), params: { user: { email: @basic.email, password: @basic_password } }
    end

    it 'show' do
      get user_path(@basic)
    end

    it 'destroy' do
      delete user_path(@basic)
    end
  end

  #
  # TODO: Most of these should probably all be in a helper file somewhere.
  #

  def verify_success_and_follow
    expect(response).to have_http_status(302)
    follow_redirect!
  end

  def verify_success_and_follow_with_text(text)
    verify_success_and_follow
    expect(response.body).to include(text)
  end

  def admin_login
    post login_path, params: { user: { email: @admin.email, password: @admin_password } }
    follow_redirect!
  end

  def basic_login
    post login_path, params: { user: { email: @basic.email, password: @basic_password } }
    follow_redirect!
  end

  def valid_user_edit(user)
    put user_path(user), params: { user: { email: 'new-email@domain.com' } }
    verify_success_and_follow_with_text('User info updated.')
    expect(User.find_by_id(@basic.id).try(:email)).to eq('new-email@domain.com')
  end

  def valid_user_password_change(user)
    put update_password_user_path(user), params: { user: { password: 'new-secret', password_confirmation: 'new-secret' } }
    verify_success_and_follow_with_text('User password changed.')
    expect(User.find_by_id(user.id).authenticate('new-secret')).to be_truthy
  end

  def expect_user_shown(user)
    expect(response.body).to include('User Details')
    expect(response.body).to include(user.email)
  end

  def expect_access_denied
    verify_success_and_follow_with_text('Access denied. You must login as an authorized user.')
  end
end
