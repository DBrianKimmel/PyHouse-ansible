# Ansible Role: install_zero_tier

Installs a Zero-Tier VPN for Linux.

## Requirements

None

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yaml`):

    zero_tier_state: started
    zero_tier_enabled_at_boot: true

Controls the state of the Zero Tier service; whether it should be running (`zero_tier_state`) and/or enabled on system boot (`zero_tier_enabled_at_boot`).

## Dependencies

None.

## Example Playbook

    - hosts: server
      vars_files:
        - vars/main.yaml
      roles:
        - { role: install-zero-tier }

*Inside `vars/main.yaml`*:

    xx_yy_zz:
      - 111
      - 222

## License

MIT

## Author Information

This role was created in Sept 27, 2020 by D. Brian Kimmel
