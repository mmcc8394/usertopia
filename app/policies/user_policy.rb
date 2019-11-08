class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || itself?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def edit?
    user.admin? || itself?
  end

  def update?
    user.admin? || itself?
  end

  private

  def itself?
    user.id == record.id
  end
end