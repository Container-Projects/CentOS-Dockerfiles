FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org

ENV container docker
LABEL RUN="docker run -it --name NAME --privileged --ipc=host --net=host --pid=host -e HOST=/host -e NAME=NAME -e IMAGE=IMAGE -v /sys/fs/selinux:/sys/fs/selinux:ro -v /run:/run -v /var/log:/var/log -v /etc/localtime:/etc/localtime -v /:/host IMAGE"

RUN [ -e /etc/yum.conf ] && sed -i '/tsflags=nodocs/d' /etc/yum.conf || true

# Reinstall all packages to get man pages for them
RUN yum -y reinstall "*" && yum clean all


# Swap out the systemd-container package and install all useful packages
RUN yum -y install \
           wget \
           lsof \
           fio \
           kernel \
           e2fsprogs \
           crash \
           strace \
           ltrace \
           tcpdump \
           abrt \
           pcp \
           systemtap \
           perf \
           bc \
           blktrace \
           btrfs-progs \
           ethtool \
           file \
           findutils \
           gcc \
           gdb \
           git \
           glibc-common \
           glibc-utils \
           hwloc \
           iotop \
           iproute \
           iputils \
           less \
           pciutils \
           ltrace \
           mailx \
           man-db \
           nc \
           netsniff-ng \
           net-tools \
           numactl \
           numactl-devel \
           passwd \
           perf \
           procps-ng \
           psmisc \
           screen \
           strace \
           sysstat \
           systemtap-client \
           tar \
           tcpdump \
           vim-enhanced \
           xauth \
           which \
           ostree \
           rpm-ostree \
           docker \
           python-docker-py \
           docker-selinux \
           kubernetes-client \
           kubernetes-node \
           kubernetes-devel \
           kubernetes-master \
           gdb-gdbserver \
           vim-minimal \
           bash-completion \
           subscription-manager \
           python-rhsm \
           rootfiles \
           yum-utils \
           && yum clean all

RUN yum -y swap -- install http://escore:escore@mirror.easystack.cn/kojifiles/packages/escore-release/5/1.5es.4/x86_64/escore-release-5-1.5es.4.x86_64.rpm -- remove centos-release
RUN sed -i s/production/5.0.3/g /etc/yum.repos.d/ESCore.repo
RUN yum clean all
RUN yum -y swap -- remove sos -- install sos
RUN yum clean all

# Set default command
CMD ["/usr/bin/bash"]
