#!/bin/bash

INVENTORY="../../inventories/hosts.yaml"
CMD="ansible-playbook --vault-password-file ~/.vault-pass.txt  -i $INVENTORY  -vvv  new-pi.yaml"
echo "Executing:  $CMD"
echo ' '
$CMD

### END DBK