FROM centos:centos7

MAINTAINER kwancr92@gmail.com

RUN yum -y install yum-utils && \
	yum -y install gcc nc && \
	yum -y install wget pcre-devel openssl openssl-devel telnet patch && \
	mkdir -p /root/nginx /root/luajit /root/sockproc /root/nginx/conf /root/var/run/nginx /root/var/run/nginx/logs

COPY ngx-proxy-module.tar /root/nginx
COPY LuaJIT-2.0.5.tar.gz /root/luajit
COPY shell.lua           /root/luajit
COPY nginx-1.12.2.tar.gz /root/nginx
COPY v0.10.12rc2.tar.gz  /root/nginx
COPY v0.2.14.tar.gz      /root/nginx
COPY sockproc.c          /root/nginx
COPY nginx.conf          /root/nginx/conf
COPY install.sh          /root/install.sh
COPY install-lj2.sh      /root/luajit/install-lj2.sh

RUN chmod 755 /root/install.sh && \
	chmod 755 /root/luajit/install-lj2.sh

ENTRYPOINT ["/root/install.sh"]
