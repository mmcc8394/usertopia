class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || viewing_self?
  end

  private

  def viewing_self?
    user.id == record.id
  end
end