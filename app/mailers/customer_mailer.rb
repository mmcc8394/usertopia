class CustomerMailer < ApplicationMailer
  def contact_us
    @message = params[:message]
    mail(to: 'contact-us@mycompany.com', subject: "Customer Request (#{DateTime.now.strftime('%D @ %T')})")
  end
end
