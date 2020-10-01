# Ansible Role: add_admin_user

Add the admin user - usualy 'briank'.

This in one of the first rolls to be invoked on a new computer setup.
As such, it hs no necessary roles to precede it.
It adds an administrative user, in my case it is 'briank'.
The administrative user gets virtually every group ID as the 'pi' user has.

## Requirements

None.

## Role Variables

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

## Dependencies

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

## Namespace

The namespace for this role is 'admin_user'

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

## License

MIT

## Author Information

This role was created in Sept 27, 2020 by D. Brian Kimmel
