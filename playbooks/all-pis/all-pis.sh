#!/bin/bash

INVENTORY="-i ../../inventories/hosts.yaml "
DEBUG="-vvv "
PASSWD="--vault-password-file  ~/.vault-pass.txt "
CMD="ansible-playbook ${INVENTORY} ${PASSWD} ${DEBUG} all-pis.yaml"
echo "Executing:  $CMD"
echo ' '
$CMD
