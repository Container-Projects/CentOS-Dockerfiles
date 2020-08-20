FROM registry.centos.org/centos/centos:7

LABEL maintainer="Shawn Wang <shawn.wang@easystack.cn>"
LABEL VERSION="1.15.0" ARCHITECTURE="amd64"

ARG SSH_PRIVATE_KEY

# RUN yum -y --setopt=tsflags=nodocs update
RUN yum -y --setopt=tsflags=nodocs install epel-release
RUN yum -y --setopt=tsflags=nodocs install koji-builder ssh
RUN yum -y --setopt=tsflags=nodocs install lsof createrepo_c
RUN yum clean all

RUN cp /etc/kojid/kojid.conf /etc/kojid/kojid.conf.backup
RUN mkdir -p /root/.ssh/
COPY kojid.conf /etc/kojid/kojid.conf
COPY serverca.crt /etc/kojid/serverca.crt
RUN touch /etc/kojid/client.crt
RUN touch /root/.ssh/id_rsa
#COPY client.crt /etc/kojid/client.crt
#COPY id_rsa /root/.ssh/id_rsa

COPY entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/entrypoint.sh / # backwards compat
ENTRYPOINT  ["entrypoint.sh"]
CMD ["run-kojid"]
