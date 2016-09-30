#!/usr/bin/env bash

set -e

sudo yum install -y libxslt-devel libxml2-devel libvirt-devel libguestfs-tools-c ruby-devel

vagrant plugin install vagrant-libvirt

sudo service libvirtd restart