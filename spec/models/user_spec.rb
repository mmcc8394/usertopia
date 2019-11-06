require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) { @user = User.new({ email: 'user@domain.com', password: 'some-secret', password_confirmation: 'some-secret' }) }

  context 'successful CRUD operations' do
    it 'creates' do
      expect(@user.save).to eq(true)
    end

    it 'read' do
      @user.save!
      u = User.first
      expect(u.try(:email)).to eq(@user.email)
    end

    it 'update' do
      @user.save!
      expect(@user.update({ email: 'new_user@somedomain.com', password: 'new-secret', password_confirmation: 'new-secret' })).to eq(true)
    end

    it 'delete' do
      @user.save!
      expect(@user.destroy).to be_truthy
    end
  end

  context 'fails to create an invalid user' do
    after(:each) { expect(@user.save).to eq(false) }

    it 'blank email' do
      @user.email = ''
    end

    it 'nil email' do
      @user.email = nil
    end

    it 'blank password' do
      @user.password = @user.password_confirmation = ''
    end

    it 'nil password' do
      @user.password = @user.password_confirmation = nil
    end

    it 'password too short' do
      @user.password = @user.password_confirmation = 'abcde'
    end

    it 'mismatched password' do
      @user.password = 'bad-password'
    end

    it 'no confirmation password' do
      @user.password_confirmation = ''
    end

    it 'duplicate email' do
      @user.save
      @user = User.new({ email: 'user@domain.com', password: 'new-secret', password_confirmation: 'new-secret' })
    end
  end

  context 'fails to edit invalid user' do
    before(:each) { @user.save! }

    it 'blank email' do
      expect(@user.update({ email: '' })).to eq(false)
    end

    it 'nil email' do
      expect(@user.update({ email: nil })).to eq(false)
    end

    it 'too short password' do
      @user.update({ password: 'abcde' })
    end

    it 'nil password' do
      @user.update({ password: nil })
    end

    it 'mismatched password' do
      expect(@user.update({ password: 'new-password', password_confirmation: 'bad-password' })).to eq(false)
    end

    it 'duplicate email' do
      User.create!({ email: 'second@domain.com', password: 'new-secret', password_confirmation: 'new-secret' })
      expect(@user.update({ email: 'second@domain.com' })).to eq(false)
    end
  end
end
