require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  before(:each) do
    @user = User.create!({ email: 'user@domain.com', password: 'some-secret', password_confirmation: 'some-secret', roles: [ 'basic' ] })
    @mail = UserMailer.welcome(@user)
  end

  context 'user creation' do
    it 'queues up welcome email' do
      expect { @mail.deliver_later }.to have_enqueued_job(ActionMailer::MailDeliveryJob).with('UserMailer', 'welcome', 'deliver_now', { args: [ @user ] })
    end

    it 'with correct from emil' do
      expect(@mail.from).to eq([ 'from@example.com' ])
    end

    it 'with correct to emil' do
      expect(@mail.to).to eq([ @user.email ])
    end

    it 'with correct subject line' do
      expect(@mail.subject).to eq('New User Account Created')
    end

    it 'proper body' do
      expect(@mail.body.encoded).to match('Your account has been created.')
    end
  end

  pending 'reset password request'
  pending 'password reset'
end
