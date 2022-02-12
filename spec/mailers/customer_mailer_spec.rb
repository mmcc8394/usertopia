require "rails_helper"

RSpec.describe CustomerMailer, type: :mailer do
  context 'customer basic email' do
    before(:each) do
      @message = Message.create!({ name: 'Jane Doe', phone: '(800) 272-0897 ext 23', email: 'jane@doe.com' })
      @mail = CustomerMailer.with(message: @message).contact_us
    end

    it 'queues up customer message' do
      expect { @mail.deliver_later }.to have_enqueued_mail(CustomerMailer, :contact_us)
    end

    it 'from email' do
      expect(@mail.from).to eq([ 'from@mycompany.com' ])
    end

    it 'to email' do
      expect(@mail.to).to eq([ 'contact-us@mycompany.com'  ])
    end

    it 'customer name in message' do
      expect(@mail.body.encoded).to match(@message.name)
    end

    it 'customer phone number in message' do
      expect(@mail.body.encoded).to match('272-0897 ext 23')
    end

    it 'customer email in message' do
      expect(@mail.body.encoded).to match(@message.email)
    end
  end
end
