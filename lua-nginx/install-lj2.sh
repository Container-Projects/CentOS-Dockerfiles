#!/bin/sh

cd /root/luajit && tar -zxf LuaJIT-2.0.5.tar.gz && cd LuaJIT-2.0.5
make
make install PREFIX=/root/luajit
