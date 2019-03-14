class RolifyRolesException < StandardError
  # Exception class for RolifyRoles library

  attr_accessor :failed_action
  def initialize(msg = "Rolify Role exception raised")
    @failed_action = Role
    super
  end
end
