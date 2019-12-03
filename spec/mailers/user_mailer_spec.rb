require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  before(:each) { @user = User.create!({ email: 'user@domain.com', password: 'some-secret', password_confirmation: 'some-secret', roles: [ 'basic' ] }) }

  context 'user creation' do
    before(:each) { @mail = UserMailer.welcome(@user) }

    it 'queues up welcome email' do
      expect { @mail.deliver_later }.to have_enqueued_job(ActionMailer::MailDeliveryJob).with('UserMailer', 'welcome', 'deliver_now', { args: [ @user ] })
    end

    it 'from email' do
      expect(@mail.from).to eq([ 'from@example.com' ])
    end

    it 'to email' do
      expect(@mail.to).to eq([ @user.email ])
    end

    it 'subject line' do
      expect(@mail.subject).to eq('New User Account Created')
    end

    it 'body' do
      expect(@mail.body.encoded).to match('Your account has been created.')
    end
  end

  context 'reset password request' do
    before(:each) { @mail = UserMailer.reset_password_link(@user) }

    it 'queues up reset password email' do
      expect { @mail.deliver_later }.to have_enqueued_job(ActionMailer::MailDeliveryJob).with('UserMailer', 'reset_password_link', 'deliver_now', { args: [ @user ] })
    end

    it 'from email' do
      expect(@mail.from).to eq([ 'from@example.com' ])
    end

    it 'to email' do
      expect(@mail.to).to eq([ @user.email ])
    end

    it 'subject line' do
      expect(@mail.subject).to eq('Password Reset Link')
    end

    it 'body' do
      expect(@mail.body.encoded).to match(@user.password_reset_guid)
    end
  end

  pending 'password reset'
end
