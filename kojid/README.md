IMG=$1

C_KEY="${C_KEY:-client.crt}"
SSH_KEY="${SSH_KEY:~/.ssh/id_rsa}"

podman run -v ${C_KEY}:/etc/kojid/client.crt -v ${SSH_KEY}:/root/.ssh/id_rsa $1
