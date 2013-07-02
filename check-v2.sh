#!/bin/bash

SSH_URI=$1


if [ -z "$SSH_URI" ]; then
  echo "Usage: check-v2 UUID@IP"
  exit 1
fi


ssh -o "StrictHostKeyChecking no" $SSH_URI echo '$CARTRIDGE_VERSION_2'
