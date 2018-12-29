Name:      PyHouse-ansible/README.md
Author:    D. Brian Kimmel
Contact:   D.BrianKimmel@gmail.com
Copyright: (c) 2018-2018 by D. Brian Kimmel
Created:   2018-12-15
Updated:   2018-12-15
License:   MIT License
Summary:   This is the design documentation of PyHouse-ansible.

# PyHouse-ansible

## Tools

This package creates four tools:
	ansible-ansible that fixes/updates the ansible environment that works on the rest of the package.
	ansible-new-pi that is used on a brand new raspberry pi to set it up to be a part of the system.
	ansible-development is used to install a set of roles for a particular computer.
	ansible-production is used to keep everything up-to-date.

### ansible-ansible

This tool is run (perhaps twice) to set up the ansible package as a whole.
It copies scripts. to their proper place.
If you change this the ansible-ansible script, you may need to run (the old script) once to put the new script in
place and then run it again to perform the new actions within the new script.

### ansible-new-pi

This tool will install enough software and configuration to make the computer a part of a house farm of raspberry pis.
To use this tool, you must plug ethernet into the pi and then find the IP address (V4) of the pi.
Take this IP address and put it into the vars file:
	PyHouse-ansible/inventories/setup-pi/host_vars/raspberrypi.yaml

### ansible-development

This is designed to work with one raspberry pi computer.
It will set it up with the configured role.

### ansible-production

This is designed to work with all production device in many different physical locations.
It typically takes a long time to run.

## X


### END DBK
