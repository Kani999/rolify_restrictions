module RolifyRoles
  # Set config file with defined restrictions
  path = File.join(Rails.root, 'config', 'rolify_roles.yml')
  @config = YAML.load_file(path)

  def self.config
    @config
  end

  # returns array of avaliable resources from config file 
    # example: User.first.add_role :role_name, Model.first - where Model is an avaliable resource
  def self.available_resources
    @resources = []
    RolifyRoles.config.values.each do |res|
      @resources.push(res['resource'])
    end

    @resources.compact.flatten.uniq
  end

  # Based on config/rolify_roles.yml
  # :single_resource_role -> Project
  # :multiple_resource_role -> On Project, Audit
  # :resourceless_role -> Only without resource

  def add_role(role, instance = nil)
    # Role was not defined
      # example: User.last.add_role(nil)
    raise RolifyRolesException.new, "Role is not defined!" if RolifyRoles.config[role].nil?

    # For Resource Less roles
    # Target has to be nil (Model instance)
      # example: User.last.add_role :resourceless_role 
    if instance.blank? && RolifyRoles.config[role]['resource'].blank?
      ActiveRecord::Base.transaction do
        super(role, instance)
      end

    # Model Instance and Role Resource exists
    elsif instance.present? && RolifyRoles.config[role]['resource'].present?
      # Array of possible resources (:multiple_resource_role)
      if RolifyRoles.config[role]['resource'].instance_of?(Array)
        # raise error if Model is not allowed for defined Role
	      # example: User.last.add_role :single_resource_role, Audit.last
        raise RolifyRolesException.new, "Not allowed - Forbidden resource #{instance.class.name} for role #{role}"\
          unless RolifyRoles.config[role]['resource'].any? { |klass| instance.instance_of? klass.constantize }
      # :single_resource_role
      else
        raise RolifyRolesException.new, "Not allowed - Forbidden resource #{instance.class.name} for role #{role}"\
         unless instance.instance_of? RolifyRoles.config[role]['resource'].constantize
      end

      # Add role if Instance is defined as a Resource for a Role
      ActiveRecord::Base.transaction do
        super(role, instance)
      end

    # Class instance passed to Resourceless Role
      # example: User.last.add_role :resourceless_role, Project.last
    elsif instance.present? && RolifyRoles.config[role]['resource'].blank?
      raise RolifyRolesException.new, "Not allowed - Role #{role} can't be assigned to any resource!"

    # Instance does not exsits but Role resource has to be defined
      # example: User.last.add_role multiple_resource_role
    elsif instance.blank? && RolifyRoles.config[role]['resource'].present?
      raise RolifyRolesException.new, "Not allowed - Target resource cannot be blank!"

    # Unexpected behavior
    else
      # TODO: raise better message
      raise RolifyRolesException.new, "Not allowed - something went wrong"
    end
  end

  # Transactions added to removing role
  def remove_role(role, instance = nil)
    ActiveRecord::Base.transaction do
      super(role, instance)
    end
  end
end
