# Ansible Role: PLAYBOOK Initialize a brand new Raspberry Pi

This playbook is only used to take a brand new pi from first boot to a base system with a new admin user installed.

This admin user is then used by all other playbooks and roles to further customize each device in the network.

This does not do any customization such as setting up IP addressing, hostname etc.

## Requirements

None.

## Playbook Variables

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yaml, vars/main.yaml, and any variables that can/should be set via parameters to the role.
Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

## Dependencies

A fresh micro SD card with the lastest Raspberry OS (Lite) imaged to the card, with an empty 'ssh' file in the boot partition.

## Namespace

The namespace for this playbook is 'bootstrap'

## Example Playbook

new_pi.sh

Note: When run, this playbook will ask for the pi user password.
Plase type 'raspberry' (unless you changed it already) at the password prompt.

## License

MIT

## Author Information

This role was created in Oct 12, 2020 by D. Brian Kimmel

### END DBK