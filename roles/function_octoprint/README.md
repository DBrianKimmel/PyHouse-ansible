# Role Name: function_octoprint

Install octoprint in s virtual environment on a remote Rasperry Pi.

## Requirements

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here.
For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

## Role Variables

The following variables may be defined to customize this role:

- `virtualenv_path`: Target directory in which to create/update virtualenv (required).
- `virtualenv_user`: User to become for creating/updating the virtualenv;
   default is the current user (i.e. `ansible_user` or `ansible_ssh_user`).
- `virtualenv_default_os_packages`: OS packages required in order to create a virtualenv
   There is usually no need to change this option unless running on a system using a different `ansible_pkg_mgr`;
   default is `{ apt: ['python-dev', 'python-virtualenv'], yum: ['python-devel', 'python-virtualenv'] }`.
- `virtualenv_os_packages`: OS packages to install to support the virtualenv, indexed by `ansible_pkg_mgr`;
   default is `{}`.
- `virtualenv_easy_install_packages`: Python packages to install globally using `easy_install`;
   default is `[]`.
- `virtualenv_easy_install_executable`: Alternate executable to use for global `easy_install` packages;
   default is `omit` to use the `easy_install` command found in the path.
- `virtualenv_global_packages`: Python packages to install globally using `pip`;
   default is `[]`.
- `virtualenv_pip_executable`: Alternate executable to use for global `pip` packages;
   default is `omit` to use the `pip` command found in the path.
- `virtualenv_command`: Alternate executable to use to create virtualenv;
   default is `omit` to use `virtualenv` command found in the path.
- `virtualenv_python`: Python version to use to create virtualenv;
   default is `omit` to use the Python interpreter used by Ansible.
- `virtualenv_default_package`: Default package to install when creating the virtualenv;
   default is `pip`.
- `virtualenv_site_packages`: Boolean indicating whether virtualenv will use global site packages;
   default is `no`.
- `virtualenv_pre_packages`: Python packages to `pip` install inside the virtualenv before requirements files;
   default is `[]`. This option can also be used to remove packages no longer needed in the virtualenv.
- `virtualenv_requirements`: List of requirements files to `pip` install inside the virtualenv;
   default is `[]`. These paths must already be present on the remote system.
- `virtualenv_post_packages`: Python packages to `pip` install inside the virtualenv after requirements files;
   default is `[]`. This option can also be used to remove packages no longer needed in the virtualenv.
- `virtualenv_recreate`: Boolean indicating whether to delete and recreate the virtualenv;
   default is `no`.

The following variable may be defined for the play or role invocation (but not as an inventory group or host variable):

- `virtualenv_notify_on_updated`: Handler name to notify when the virtualenv was created or updated.
   default is `"virtualenv updated"` it is generally recommended for custom handlers to listen for `"virtualenv updated"` instead of changing the notification name.

Each item in a package list above may be specified as a string with only the package name or as a hash with `name`, `state` or `version` keys, e.g.:

```
    - package1
    - name: package2
      state: absent
    - name: package3
      version: 1.2
```

OS package lists are a hash indexed by the package manager, e.g.:

```
    apt:
      - package1
      - name: package2-dev
        state: absent
    yum:
      - package1
      - name: package2-devel
        state: absent
    foo_pkg_mgr:
      - foo-package1
```

This role can create a virtualenv as another user, specified by `virtualenv_user`, and will use the `become_method` specified for the host/play/task.
OS and global packages will only be installed when `ansible_user`, `ansible_ssh_user` or `ansible_become_user` is `root`.
The following example combinations of users are listed below with their expected results:

- `ansible_user=root`: OS and global packages will be installed; virtualenv will be owned by `root`.
- `ansible_user=root virtualenv_user=other`: OS and global packages will be installed; `become` will be used; virtualenv will be owned by `other`.
- `ansible_user=other`: OS and global packages will *not* be installed; virtualenv will be owned by `other`.
- `ansible_user=other virtualenv_user=another`: OS and global packages will *not* be installed; `become` will be used; virtualenv will be owned by `another`.
   This combination may fail if `other` cannot become `another`.
   The Ansible 2.1 note below may also apply in this case.
- `ansible_user=other ansible_become_user=root`: OS and global packages will be installed; `become` will be used; virtualenv will be owned by `other`.
- `ansible_user=other ansible_become_user=root virtualenv_user=another`: OS and global packages will be installed; `become` will be used; virtualenv will be owned by `another`.
   You may need to define `allow_world_readable_tmpfiles` in your `ansible.cfg` (which still generate a warning instead of an error) or use another approach to support one unprivileged user becoming another unprivileged user.


## Dependencies

Based on:

```
https://github.com/cchurch/ansible-role-virtualenv
```

## Example Playbook

The following example playbook installs `libjpeg` as a system dependency,
creates or updates a virtualenv, installs specific packages, installs
requirements, then removes an old package no longer needed:

```
    - hosts: all
      roles:
        - name: cchurch.virtualenv
          vars:
            virtualenv_path: ~/env
            virtualenv_os_packages:
              apt: [libjpeg-dev]
              yum: [libjpeg-devel]
            virtualenv_pre_packages:
              - name: Django
                version: 1.11.26
              - Pillow
            virtualenv_requirements:
              - ~/src/requirements.txt
            virtualenv_post_packages:
              - name: PIL
                state: absent
      handlers:
        - name: custom virtualenv handler
          debug:
            msg: "virtualenv in {{ virtualenv_path }} was updated."
          listen: virtualenv updated
```

## License

MIT

## Author Information

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
