Name:           proxy
Version:        1.12
Release:        1%{?dist}
Summary:        fast forward proxy server with luajit

Group:          System Environment/Daemons
License:        BSD
URL:            http://nginx.org
Source0:        LuaJIT-2.0.5.tar.gz
Source1:        ngx-proxy-module.tar
Source2:        v0.10.12rc2.tar.gz
Source3:        v0.2.14.tar.gz
Source4:        ranger.tar.gz
Source5:        nginx-1.12.2.tar.gz
Source6:        shell.lua
Source7:        ranger.conf
Source8:        sockproc.c

BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
#Patch0:         some patch file

%description
This package contains the Forward Proxy Server

# ### ### ### ###
# Prep
# ### ### ### ###

%define nginx_pre /usr/local/nginx
%define luajit_pre /usr/local/luajit

%prep
%{__mkdir} -p %{name}-%{version}
%setup -T -D -a 0
%setup -T -D -a 1
%setup -T -D -a 2
%setup -T -D -a 3
%setup -T -D -a 4
%setup -T -D -a 5


# ### ### ### ###
# Build
# ### ### ### ###

# %patch -P 0 -p0

%build

# ### ### ### ###
##  Test
# ### ### ### ###
pwd

# ### ### ### ###
##  pt1 - Executable
# ### ### ### ###
# Build luajit
cd LuaJIT-2.0.5
make %{?_smp_mflags}
make install DESTDIR=%{buildroot}

export LUAJIT_LIB=%{buildroot}/usr/local/lib
export LUAJIT_INC=%{buildroot}/usr/local/include/luajit-2.0

# Config Nginx
cd ../nginx-1.12.2
patch -p1 < ../ngx_http_proxy_connect_module-master/proxy_connect.patch
./configure --prefix=%{nginx_pre} \
          --with-ld-opt="-Wl,-rpath,%{buildroot}/usr/local/lib" \
          --with-http_stub_status_module \
          --with-http_ssl_module \
          --add-module=../ngx_devel_kit-0.2.14 \
          --add-module=../lua-nginx-module-0.10.12rc2 \
          --add-module=../ngx_http_proxy_connect_module-master

make %{?_smp_mflags}

# ### ### ### ###
## pt2 - Documentation
# ### ### ### ###

# Builds HTML documentation
# make luadoc

# ### ### ### ###
# Install
# ### ### ### ###

%install

cd nginx-1.12.2
make -f objs/Makefile install DESTDIR=%{buildroot}

# %{__mkdir} -p %{buildroot}/usr/local/nginx/ranger/resty
# cp %{SOURCE6} %{buildroot}/luajit/usr/local/lib/resty
cp %{SOURCE7} %{buildroot}/usr/local/nginx/conf/nginx.conf
tar -zxf %{SOURCE4} -C %{buildroot}/usr/local/nginx

cp %{SOURCE8} %{buildroot}/usr/local/nginx
cd %{buildroot}/usr/local/nginx
gcc -o sockproc ./sockproc.c
# cp sockproc %{buildroot}
# ./sockproc /tmp/shell.sock
# chmod 0666 /tmp/shell.sock

cd %{buildroot}/usr/local/nginx/ranger
sed -i s^ranger_install^/usr/local/nginx/ranger^g %{buildroot}/usr/local/nginx/conf/nginx.conf
sed -i s^ranger_install^/usr/local/nginx/ranger^g %{buildroot}/usr/local/nginx/ranger/http_block.conf


export QA_RPATHS=$[ 0x0002 ]

# ### ### ### ###
# Clean
# ### ### ### ###

%clean
rm -rf %{buildroot}

# ### ### ### ###
# Files
# ### ### ### ###

%files
%defattr(-,root,root,-)
/usr/local/nginx/*


%changelog
* Mon May 02 2018 World <- chan666
- Initial packaging
