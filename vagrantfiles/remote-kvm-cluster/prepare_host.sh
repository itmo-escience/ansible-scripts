#!/usr/bin/env bash

set -e

sudo yum install -y libxslt-devel libxml2-devel libvirt-devel libguestfs-tools-c ruby-devel

echo "<pool type='dir'>" > pool.xml
echo "  <name>fcpir_500G</name>" >> pool.xml
echo "      <target>" >> pool.xml
echo "          <path>/fcpir_500G_vol</path>" >> pool.xml
echo "      </target>" >> pool.xml
echo "</pool>" >> pool.xml

sudo virsh pool-create pool.xml

LIBVIRT_ACCESS_POLICY=/etc/polkit-1/localauthority/50-local.d/50-org.libvirt-remote-access.pkla
echo "[Remote libvirt SSH access]" > $LIBVIRT_ACCESS_POLICY
echo "Identity=unix-user:nano" >> $LIBVIRT_ACCESS_POLICY
echo "Action=org.libvirt.unix.manage" >> $LIBVIRT_ACCESS_POLICY
echo "ResultAny=yes" >> $LIBVIRT_ACCESS_POLICY
echo "ResultInactive=yes" >> $LIBVIRT_ACCESS_POLICY
echo "ResultActive=yes" >> $LIBVIRT_ACCESS_POLICY

sudo service libvirtd restart
