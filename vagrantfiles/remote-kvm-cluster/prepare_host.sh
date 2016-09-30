#!/usr/bin/env bash

## run it in the way: ssh -tt 192.168.13.112 'bash -s' < prepare_host.sh
set -e

sudo yum install -y libxslt-devel libxml2-devel libvirt-devel libguestfs-tools-c ruby-devel

echo "<pool type='dir'>" > pool.xml
echo "  <name>fcpir_500G</name>" >> pool.xml
echo "      <target>" >> pool.xml
echo "          <path>/fcpir_500G_vol</path>" >> pool.xml
echo "      </target>" >> pool.xml
echo "</pool>" >> pool.xml

sudo virsh pool-create pool.xml

sudo service libvirtd restart
