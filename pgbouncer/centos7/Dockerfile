FROM centos
MAINTAINER Mohammed Zeeshan Ahmed <moahmed@redhat.com>

ENV POSGRESQL_VERSION 9.4
ENV POSGRESQL_VERSION_NODOT 94

RUN yum -y update
ADD ./install-pgbouncer.sh ./
RUN /bin/bash ./install-pgbouncer.sh