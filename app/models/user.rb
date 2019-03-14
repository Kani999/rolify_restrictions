class User < ApplicationRecord
  # ...

  # Include created library to your User model (or another one) where the Roles will be included

  # Sets up custom checks for function like add_roles etc. (lib/rolify_roles.rb)
  prepend RolifyRoles
  rolify strict: true

  # ...
end
