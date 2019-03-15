# Rolify Restrictions
Library for extending gem https://github.com/RolifyCommunity/rolify which allows you to define some restrictions for defining roles for users.

### Motivation
I had to override the standard behavior of `add_role` command to add some logic when the Role to a Resource can be inserted or not.

My library now supporting only two ways of defining a role
  1. Adding a role to a user for instance of the defined class 
  2. Adding a role to the user without any instance or class 

I'll try to extend this library to support more cases (which I did not need)
  - Adding a role to User for a whole Class (not only instances of a class)

### Structure
- **config**
  - contains configuration file `rolify_roles.yml` where you define  Roles that can be created and to which instance it can be associated 
  - `initializers`
    - You have to require new library in your application initializer

- **app/models**
  - In a model User, that will be probably used to provide an authentication solution, you have to include this Library for a usage  

- **lib**
  - Contains a logic with defined restrictions described in Motivation

# Test
 
## Correct State
- `User.last.add_role :multiple_resource_role, Project.last`
- `User.last.add_role :multiple_resource_role, Audit.last`
- `User.last.add_role :single_resource_role, Project.last`
- `User.last.add_role :resourceless_role`

## Raise Errors
### Undefined Role
- `User.last.add_role :undefined`
  - RolifyRolesException: Role is not defined!

### Multiple Resource Role
- `User.last.add_role :multiple_resource_role`
  - RolifyRolesException: Not allowed - Target resource cannot be blank!

- `User.last.add_role :multiple_resource_role, Project`
  - Not allowed - Forbidden resource Class for role multiple_resource_role

- `User.last.add_role :multiple_resource_role, Object.new`
  - Not allowed - Forbidden resource Object for role multiple_resource_role

### Single Resource Role
- `User.last.add_role :single_resource_role`
  - RolifyRolesException: Not allowed - Target resource cannot be blank!

- `User.last.add_role :single_resource_role, Project`
  - Not allowed - Forbidden resource Class for role single_resource_role

- `User.last.add_role :single_resource_role, Object.new`
  - Not allowed - Forbidden resource Object for role single_resource_role

### Resourceless Role
- `User.last.add_role :resourceless_role, Project`
  - RolifyRolesException: Not allowed - Role resourceless_role can't be assigned to any resource!

- `User.last.add_role :resourceless_role, Project.first`
  - RolifyRolesException: Not allowed - Role resourceless_role can't be assigned to any resource!

# Docker Compose
I've added a docker compose file, which creates an one container for Rails application and second for a mysql database

To try the library out run following commands

1. `cd RolifyRestriction`
2. `docker-compose build`
3. `docker-compose up -d` # Keep containers up and running
4. `sudo docker-compose run web bash` # Opens bash terminal at rails application
5. `rake db:create` # Create database on mysql container 
6. `rake db:migrate` # Run migrations to create table
7. `rake db:seed` # Insert test data into database
8. `rails c` # Open rails console
9. Test it! - Commands are listed above
