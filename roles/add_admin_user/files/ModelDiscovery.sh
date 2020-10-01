#!/bin/bash

rev=`cat /proc/cpuinfo | mawk -- '/Revision/  {print $3}'`
if [[ $rev == '0002' ]]; then
	model='B1'
	ram=256
elif [[ $rev == '0003' ]]; then
	model='B1 No Fuses, D14 Removed'
	ram=256
elif [[ $rev == '0004' ]] || [[ $rev == '0005' ]] || [[ $rev == '0006' ]]; then
	model='B2'
	ram=256
elif [[ $rev == '0007' ]] || [[ $rev == '0008' ]] || [[ $rev == '0009' ]]; then
	model='A'raspi_config_auth_test_username: pi
raspi_config_auth_test_password: raspberry
	
	ram=256raspi_config_auth_test_username: pi
raspi_config_auth_test_password: raspberry
	
elif [[ $rev == '000d' ]] || [[ $rev == '000e' ]] || [[ $rev == '000f' ]]; then
	model='B2'
	ram=512
elif [[ $rev == '0010' ]] || [[ $rev == '0013' ]] || [[ $rev == '900032' ]]; then
	model='B+'
	ram=512
elif [[ $rev == '0011' ]] ; then
	model='Compute Module'
	ram=0
elif [[ $rev == '0012' ]] ; then
	model='A+'
	ram=256
elif [[ $rev == '0014' ]] ; then
	model='Compute Module; Embest, China'
	ram=0
elif [[ $rev == '0015' ]] ; then
	model='A+; Embest, China'
	ram=256
elif [[ $rev == '0015' ]] ; then
	model='A+; Embest, China'
	ram=512
elif [[ $rev == 'a01041' ]] ; then
	model='2B v1.1; Sony, UK'
	ram=1024
elif [[ $rev == 'a02082' ]] ; then
	model='3B; Sony, UK'
	ram=1024
elif [[ $rev == 'a020d3' ]] ; then
	model='3B+ v1.3; Sony, UK'
	ram=1024
elif [[ $rev == 'a21041' ]] ; then
	model='2B v1.2; Embest, China'
	ram=1024
elif [[ $rev == 'a22042' ]] ; then
	model='2B v1.2; Embest, China'
	ram=1024
elif [[ $rev == 'a22082' ]] ; then
	model='3B; Embest, China'
	ram=1024
elif [[ $rev == '900092' ]] ; then
	model='0 v1.2'
	ram=512
elif [[ $rev == '900093' ]] ; then
	model='0 v1.3'
	ram=512
elif [[ $rev == '0x9000C1' ]] ; then
	model='0W'
	ram=512
else
	echo "ERROR no such Revision: as $rev"
fi

echo "Raspberry Pi Model: $model"
echo "    RAM: $ram"

## END DBK 

