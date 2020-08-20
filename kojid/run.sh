#!/bin/bash

IMG=$1

C_KEY="${C_KEY:-client.crt}"
SSH_KEY="${SSH_KEY:-$HOME/.ssh/id_rsa}"

echo podman run -v ${C_KEY}:/etc/kojid/client.crt -v ${SSH_KEY}:/root/.ssh/id_rsa $1
