FROM centos

MAINTAINER Mohammed Zeeshan Ahmed <moahmed@redhat.com>

RUN yum -y update && yum clean all
RUN yum -y install wget && yum clean all
RUN wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo &&rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
RUN yum -y install java jenkins && yum clean all

RUN -y remove wget && yum clean all
