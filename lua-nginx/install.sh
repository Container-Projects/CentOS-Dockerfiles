#!/bin/sh

/root/luajit/install-lj2.sh

export LUAJIT_LIB=/root/luajit/lib
export LUAJIT_INC=/root/luajit/include/luajit-2.0


cd /root/nginx

tar -zxf nginx-1.12.2.tar.gz
tar -zxf v0.10.12rc2.tar.gz
tar -zxf v0.2.14.tar.gz
tar -zxf ngx-proxy-module.tar

cd nginx-1.12.2
patch -p1 < /root/nginx/ngx_http_proxy_connect_module-master/proxy_connect.patch


./configure --prefix=/root/nginx/ \
          --with-ld-opt="-Wl,-rpath,/root/luajit/lib" \
          --add-module=/root/nginx/ngx_devel_kit-0.2.14 \
          --add-module=/root/nginx/lua-nginx-module-0.10.12rc2 \
          --add-module=/root/nginx/ngx_http_proxy_connect_module-master

make -f objs/Makefile install

cd /root/nginx && gcc -o sockproc ./sockproc.c
./sockproc /tmp/shell.sock
chmod 0666 /tmp/shell.sock

mkdir /root/luajit/lib/resty
cp /root/luajit/shell.lua /root/luajit/resty

/root/nginx/sbin/nginx -p /root/var/run/nginx -c /root/nginx/conf/nginx.conf

tail -200f /root/var/run/nginx/logs/access.log
