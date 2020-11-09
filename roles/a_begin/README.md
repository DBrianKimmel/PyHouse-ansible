# Role Name: a_begin

This role is run from a list of roles in the playbook.
It is run first - hence the name a_begin.
It will initialize the package manager and update each computer.
Roles that apply to all or lmost all will be done a a part of this installation

Avahi
Firewall
Harden Base OS
	SSH
VNC
VPN
	Wireguard
	ZeroTier


## Requirements

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here.
For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

## Role Variables

begin_role_enabled
* Default: true
  * Description: True = do not skip this role

## Dependencies

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

## License

MIT

## Author Information

This role was created in Oct 18, 2020 by D. Brian Kimmel
