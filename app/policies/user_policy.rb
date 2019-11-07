class UserPolicy < ApplicationPolicy
  def show?
    user.admin? || viewing_self?
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end

  private

  def viewing_self?
    user.id == record.id
  end
end