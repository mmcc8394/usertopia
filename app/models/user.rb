class User < ApplicationRecord
  has_secure_password

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, unless: :skip_password_validation?
  validates :role, presence: true

  def admin?
    role == 'admin'
  end

  def update_non_password_attributes(params)
    @skip_password_validation = true
    update(params)
  end

  private

  def skip_password_validation?
    @skip_password_validation
  end
end
