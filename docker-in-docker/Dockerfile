FROM centos:centos7
MAINTAINER Margin Hu<jhu_com@163.com>


RUN mkdir /myvol
RUN echo "hello world" > /myvol/greeting
VOLUME /myvol



#RUN DOCKER_GID=$(stat -c '%g' /var/run/docker.sock) && \
#    groupadd -g ${DOCKER_GID} docker  && \
#    usermod -aG docker 
#
#USER margin

