#!/bin/bash

MY_NAME="one-pi"

INVENTORY="-i ./inventories/hosts.yaml "
PLAYBOOK="playbooks/${MY_NAME}/${MY_NAME}.yaml"
DEBUG=" "

CUR_DIR=`pwd`
WORK_DIR=${HOME}

# Add 'Shared' if it is in the path (New scheme)
if [ -d ${WORK_DIR}/Shared ] ; then
	WORK_DIR=${WORK_DIR}/Shared
fi

# Add the workspace (new or old scheme)
if [ -d ${WORK_DIR}/Workspace ] ; then
	WORK_DIR=${WORK_DIR}/Workspace
fi
if [ -d ${WORK_DIR}/workspace ] ; then
	WORK_DIR=${WORK_DIR}/workspace
fi

# The repository 
ANS_DIR=${WORK_DIR}/PyHouse-ansible
PLAY_DIR=${ANS_DIR}/playbooks/${MY_NAME}

# Update the sh file for next time.
cp ${PLAY_DIR}/${MY_NAME}.sh  ${HOME}/bin

# go  to th base of the repository where ansible.cfg is located
cd ${ANS_DIR}

# Debugging, verfy the above work.
echo "Start Dir: ${CUR_DIR}"
echo " Play Dir: ${ANS_DIR}"
echo " Work Dir: ${WORK_DIR}"

PASSWD="--vault-password-file  ${HOME}/.vault-pass.txt "
CMD="ansible-playbook ${INVENTORY} ${PASSWD} ${DEBUG} ${PLAYBOOK}"
echo "Executing:  $CMD"
echo ' '
$CMD

cd ${CUR_DIR}

### END DBK
