#!/bin/bash
if grep "7\.[0-9]\.[0-9]*" /etc/redhat-release ;then echo "no es centos/rhel v7";exit;fi
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_10.x | sudo -E bash -
yum install -y nodejs
