class User < ApplicationRecord
  #
  # Multiple roles per user is based on this post & this gem.
  #   Post: http://dmitrypol.github.io/2016/09/29/roles-permissions.html
  #   Gem: https://github.com/brainspec/enumerize
  #
  extend Enumerize
  enumerize :roles, in: [ :admin, :basic, :auditor ], multiple: true, predicates: true
  validates :roles, presence: true

  has_secure_password

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, unless: :skip_password_validation?

  scope :active, -> { where('deleted = false') }

  def update_non_password_attributes(params)
    @skip_password_validation = true
    update(params)
  end

  def print_roles
    roles.values.join(', ')
  end

  def destroy
    update_non_password_attributes({ deleted: true })
  end

  def generate_password_reset_guid
    update({ password_reset_guid: SecureRandom.uuid })
    password_reset_guid
  end

  def clear_password_reset_guid
    update({ password_reset_guid: nil })
  end

  private

  def skip_password_validation?
    @skip_password_validation
  end
end
