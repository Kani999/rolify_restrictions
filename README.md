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
- config
  - contains configuration file `rolify_roles.yml` where you define  Roles that can be created and to which instance it can be associated 
  - `initializers`
    - You have to require new library in your application initializer

- `app/models`
  - In a model User, that will be probably used to provide an authentication solution, you have to include this Library for a usage  

- `lib`
  - Contains a logic with defined restrictions described in Motivation

# Test
 
## Passing
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

### TODO
- Docker Compose with simple rails app and data for trying this out  
