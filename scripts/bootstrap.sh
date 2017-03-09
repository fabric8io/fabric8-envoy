#!/bin/sh
yum -y update 
yum -y groupinstall 'Development Tools'
# make sure i dont miss any thing 
yum install -y cmake gmp-devel mpfr-devel libmpc-devel golang clang c-ares-devel

# we need latest version of the git for the build hence will remove the existing version
yum -y remove  git 

rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh https://centos7.iuscommunity.org/ius-release.rpm
yum -y update 
# disable base repo for installation as it has older git version
yum -y --disablerepo=base,updates --enablerepo=ius install git

# Directory that will have envoy tools
mkdir -p /opt/envoy_env
chown -R vagrant:vagrant /opt/envoy_env