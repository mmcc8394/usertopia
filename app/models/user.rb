class User < ApplicationRecord
  has_many :posts

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
  validates :first_name, :last_name, presence: true
  validates :password, length: { minimum: 6 }, if: :should_validate_password?

  scope :active, -> { where('deleted = false') }

  def self.by_password_guid(guid)
    return nil if guid.blank?
    find_by_password_reset_guid(guid)
  end

  def print_roles
    roles.values.join(', ')
  end

  def destroy
    update({ deleted: true })
  end

  def full_name
    first_name + ' ' + last_name
  end

  private

  def should_validate_password?
    new_record? || password.present?
  end
end
