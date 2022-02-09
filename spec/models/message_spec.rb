require 'rails_helper'

RSpec.describe Message, type: :model do
  before(:each) do
    @message = Message.create!({ name: 'Jane Doe', email: 'c@school.com', phone: '(555) 123-1234' })
  end

  it 'valid' do
    expect(@message.save).to be(true)
  end

  context 'invalid' do
    it 'name is nil' do
      @message.name = nil
      expect(@message.valid?).to eq(false)
      expect(@message.errors[:name]).to include("can't be blank")
    end

    it 'name is blank' do
      @message.name = ''
      expect(@message.valid?).to eq(false)
      expect(@message.errors[:name]).to include("can't be blank")
    end

    it 'phone is nil' do
      @message.phone = nil
      expect(@message.valid?).to eq(false)
      expect(@message.errors[:phone]).to include("can't be blank")
    end

    it 'phone is blank' do
      @message.phone = ''
      expect(@message.valid?).to eq(false)
      expect(@message.errors[:phone]).to include("can't be blank")
    end

    it 'email is nil' do
      @message.email = nil
      expect(@message.valid?).to eq(false)
      expect(@message.errors[:email]).to include('is invalid')
    end

    it 'email is blank' do
      @message.email = ''
      expect(@message.valid?).to eq(false)
      expect(@message.errors[:email]).to include('is invalid')
    end

    it 'email is invalid' do
      @message.email = 'janedoe'
      expect(@message.valid?).to eq(false)
      expect(@message.errors[:email]).to include('is invalid')
    end
  end
end