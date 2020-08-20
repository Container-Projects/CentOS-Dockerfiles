#!/bin/bash

set -e

if [ "$1" = 'run-kojid' ]; then
   #if [ ! -s /etc/kojid/client.crt ]; then
   #   echo "/etc/kojid/client.crt not found"
   #   echo "docker run -v client.crt /etc/kojid/client.crt <image>"
   #   exit 1
   #fi
   #
   #if [ ! -s /root/.ssh/id_rsa ]; then
   #   echo "/root/.ssh/id_rsa not found"
   #   echo "docker run -v id_rsa /root/.ssh/id_rsa <image>"
   #   exit 1
   #fi

   if [ -z "$(lsof -i:80)" ]; then
      echo "127.0.0.1 kojihub" >> /etc/hosts
      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -Nf -T -L 80:192.168.129.2:80 shawn@mirror.easystack.cn
      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -Nf -T -L 443:192.168.129.2:443 shawn@mirror.easystack.cn
   fi

   exec /usr/sbin/kojid --fg --force-lock --verbose
fi

exec $@
