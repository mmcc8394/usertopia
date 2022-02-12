class ContactsController < ApplicationController
  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      CustomerMailer.with(message: @message).contact_us.deliver_later
      redirect_to show_contact_path
    else
      flash[:alert] = @message.errors.full_messages.join('<br />')
      render action: :new
    end
  end

  def show
  end

  private

  def message_params
    params.require(:message).permit(:name, :phone, :email)
  end
end