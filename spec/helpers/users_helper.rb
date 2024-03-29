module UsersHelper
  def create_admin_user
    @admin_password = 'admin-secret'
    @admin = User.create!({ first_name: 'John', last_name: 'Smith', email: 'admin@domain.com', password: @admin_password, roles: [ 'admin' ] })
  end

  def admin_login
    post admin_login_path, params: { user: { email: @admin.email, password: @admin_password } }
    follow_redirect!
  end

  def create_basic_user
    @basic_password = 'basic-secret'
    @basic = User.create!({ first_name: 'Jane', last_name: 'Doe', email: 'basic@domain.com', password: @basic_password, roles: [ 'basic' ] })
  end

  def basic_login
    post admin_login_path, params: { user: { email: @basic.email, password: @basic_password } }
    follow_redirect!
  end

  def expect_user_shown(user)
    expect(response.body).to include('User Details')
    expect(response.body).to include(user.email)
  end

  def verify_success_and_follow
    expect(response).to have_http_status(302)
    follow_redirect!
  end

  def verify_success_and_follow_with_text(text)
    verify_success_and_follow
    expect(response.body).to include(text)
  end

  def valid_user_edit(user)
    put admin_user_path(user), params: { user: { email: 'new-email@domain.com' } }
    verify_success_and_follow_with_text('User info updated.')
    expect(User.find_by_id(@basic.id).try(:email)).to eq('new-email@domain.com')
  end

  def valid_user_password_change(user)
    put update_password_admin_user_path(user), params: { user: { password: 'new-secret', password_confirmation: 'new-secret' } }
    verify_success_and_follow_with_text('User password changed.')
    expect(User.find_by_id(user.id).authenticate('new-secret')).to be_truthy
  end

  def expect_access_denied
    expect(response).to have_http_status(403)
  end
end