#!/bin/bash
# 

# It used to be that the workspace was kept on some local computer.
# Now it is kept on the NAS box and a copy is fetched when starting up work (somehow?)

MY_NAME="all-computers"

NFS_DIR="/NFS/Vcs/Workbenches/PyHouse-ansible/"
INVENTORY="-i ./inventories/hosts.yaml "
PLAYBOOK_DIR="playbooks/${MY_NAME}/"
PLAYBOOK="${PLAYBOOK_DIR}/${MY_NAME}.yaml"
DEBUG=" "
#DEBUG=" -vvv "

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

# Be sure we are working with the latest version of PyHouse-ansible code
rcp -prv ${NFS_DIR} ${WORK_DIR}
cp -apv ${PLAYBOOK} ${NFS_DIR}

# The repository 
ANS_DIR=${WORK_DIR}/PyHouse-ansible
PLAY_DIR=${ANS_DIR}/playbooks/${MY_NAME}

# Update the sh file for next time.
cp ${PLAY_DIR}/${MY_NAME}.sh  ${HOME}/bin

# go  to the base of the repository where ansible.cfg is located
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