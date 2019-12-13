# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   "Aditya Patawari" <adimania@fedoraproject.org>

FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install python-pip; yum clean all
RUN pip install pypiserver \
    && mkdir ~/data/packages

ADD . /src

RUN cd /src; pip install -r requirements.txt

VOLUME /data/packages
USER pypiserver
WORKDIR /data
EXPOSE 8080

ENTRYPOINT ["pypi-server", "-p", "8080"]
CMD ["packages"]
