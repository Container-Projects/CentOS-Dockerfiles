# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <emailscottcollier@gmail.com>

FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

# Install the appropriate software
RUN yum -y update; yum clean all \
    && yum -y install epel-release; yum clean all \
    && yum -y install x11vnc firefox xorg-x11-server-Xvfb xorg-x11-twm tigervnc-server xterm xorg-x11-font dejavu-sans-fonts dejavu-serif-fonts xdotool; yum clean all

# Add the xstartup file into the image
ADD ./xstartup /

RUN mkdir /.vnc \
    && x11vnc -storepasswd 123456 /.vnc/passwd \
    &&  \cp -f ./xstartup /.vnc/. \
    && chmod -v +x /.vnc/xstartup \
    && sed -i '/\/etc\/X11\/xinit\/xinitrc-common/a [ -x /usr/bin/firefox ] && /usr/bin/firefox &' /etc/X11/xinit/xinitrc

EXPOSE 5901

CMD    ["vncserver", "-fg" ]
# ENTRYPOINT ["vncserver", "-fg" ]
