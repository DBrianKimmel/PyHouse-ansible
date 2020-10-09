# Role Name: install_basic_system

This role will run after the admin user is installed.
It will do all the basic setup of raspberry pi computers

## Requirements

The computer must have an Admin User set up.
The OS must be up to date.

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here.
For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

## Functions

Auto Reboot
Update OS
Backup System
Setup Timezones
Setup Avahi
Update DynamicDNS
Install basic firewall.
Setup VPN between Houses and also portable (Laptop) devices.

## Role Variables

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role.
Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

vpn_enabled - picked 

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

This role was created in Oct 7, 2020 by D. Brian Kimmel
