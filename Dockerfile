FROM centos

MAINTAINER Kamesh Sampath <kamesh.sampath@hotmail.com>

LABEL envoy.version=1.2.0

USER root

RUN useradd -ms /bin/bash envoy && \
    mkdir -p /etc/envoy && \
    chown -R envoy:envoy /etc/envoy && \
    chmod -R "g+rwX" /etc/envoy && \
    yum -y update && \
    yum -y install c-ares && \
    yum -y clean all 

VOLUME /etc/envoy
VOLUME /var/log/envoy

ADD bin/envoy /usr/local/bin/

USER envoy 

CMD ["envoy","-c","/etc/envoy/config.json"]
