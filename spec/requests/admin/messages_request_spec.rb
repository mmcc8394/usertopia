require 'rails_helper'
require 'helpers/users_helper'

RSpec.configure do |c|
  c.include UsersHelper
end

RSpec.describe "Messages", type: :request do
  context 'not logged in' do
    it 'index', focus: true do
      get admin_messages_path
      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'logged in' do
    before(:each) do
      create_basic_user
      basic_login
    end

    it 'index' do
      get admin_messages_path
      expect(response).to have_http_status(200)
    end
  end
end