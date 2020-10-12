# Ansible Role: add_admin_user

Add the admin user - usualy 'briank'.

This in one of the first rolls to be invoked on a new computer setup.
As such, it hs no necessary roles to precede it.
It adds an administrative user, in my case it is 'briank'.
The administrative user gets virtually every group ID as the 'pi' user has.

 Warning!  the pi password is changed - be sure you know what the new password is before using this role.

## Requirements

None.

## Role Variables

bootstrap_pi_user_password: $6$tiuFB7p31L$G2Z/NoFyTEz18HwOsbaTPh4fM5rSq1nratdP8YhFjyR7U6xwC7KLg4GKOGaKXLOBr6TfZBTzUN63Afp11ZOan.
	See https://docs.ansible.com/ansible/faq.html#how-do-i-generate-encrypted-passwords-for-the-user-module
	mkpasswd --method=sha-512 <new-password>


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
