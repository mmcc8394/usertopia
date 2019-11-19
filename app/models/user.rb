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

  def update_non_password_attributes(params)
    @skip_password_validation = true
    update(params)
  end

  def print_roles
    roles.values.join(', ')
  end

  private

  def skip_password_validation?
    @skip_password_validation
  end
end
