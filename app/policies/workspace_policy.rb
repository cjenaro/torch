class WorkspacePolicy < ApplicationPolicy

  def show?
    user_in_workspace?
  end

  def udpate?
    user_is_owner_or_admin?
  end

  def destroy?
    user_is_owner?
  end

  def manage_members?
    user_is_owner_or_admin?
  end
  
  private
  
  def user_in_workspace?
    record.users.include?(user)
  end

  def user_is_owner?
    membership&.owner?
  end

  def user_is_owner_or_admin?
    membership&.owner? || membership&.admin?
  end

  def membership
    @membership ||= record.memberships.find_by(user: user)
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
