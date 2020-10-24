# Ansible Role: install_vpn

A VPN is used to tie together selected computers on one or more LANs.
Each property/house may have one or more LANs and they all need to communicate with each other.
No outside computers or networks should be able to start communications with devices on these LANs.

Not all computers are configured with a VPN, it is selected in host_vars

## Requirements

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here.
For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

## Functions

Install and setup Zero-Tier vpn
Wireguard VPN

## Role Variables

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yaml, vars/main.yaml, and any variables that can/should be set via parameters to the role.
 Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

## Dependencies

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

## Namespace

The namespace for this role is 'vpn_'

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

## License

MIT

## Author Information

This role was created in Oct 1, 2020 by D. Brian Kimmel
