#!/bin/bash

__create_user() {
# Create a user to SSH into as.
SSH_USER=centos
SSH_USERPASS=Passw0rd

useradd $SSH_USER
usermod -aG wheel $SSH_USER

echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $SSH_USER)
echo ssh $SSH_USER password: $SSH_USERPASS
}

# Call all functions
__create_user
