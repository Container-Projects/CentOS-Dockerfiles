#!/usr/bin/env bash

set -ex

PGBOUNCER_NAME="pgbouncer";
PGBOUNCER_URL="https://download.postgresql.org/pub/repos/yum/${POSGRESQL_VERSION}/redhat/rhel-7.3-x86_64/";

echo -e "[pgbouncer]\nname=Postgresql\nbaseurl=${PGBOUNCER_URL}\nenabled=1\ngpgcheck=0" > /etc/yum.repos.d/pgbouncer.repo;
INSTALL_PKGS="libevent openssl pgdg-centos${POSGRESQL_VERSION_NODOT}";

yum -y install ${INSTALL_PKGS};
yum -y install ${PGBOUNCER_NAME} && yum clean all;