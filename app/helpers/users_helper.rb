module UsersHelper
  def role_text(role)
    User::USER_ROLE_MAPPING[role.to_sym]
  end

  def user_role_mapping
    User::USER_ROLE_MAPPING.invert
  end

  def user_role_mapping_for_partner(current_user)
    mapping = User::USER_ROLE_MAPPING.dup
    mapping.delete(:admin)
    mapping.delete(:owner) if current_user.is_manager?
    mapping.invert
  end

  def invite_status(user)
    user.confirmed_at ? "Verified" : "Invited"
  end

  def user_name(user)
    user.name.blank? ? "User" : user.name.split(" ").first
  end

  def user_avatar(user)
    user.name.blank? ? "U" : user.name[0]
  end
end
