#!/bin/bash

if [ $(python -c "import mesos.interface";echo $?) -ne 0 ]; then 
     wget -O mesos.interface.egg https://pypi.python.org/packages/2.7/m/mesos.interface/mesos.interface-0.24.0-py2.7.egg#md5=c4fd6fb5447276226698b63a85295877 >/dev/null 2>&1
     sudo easy_install mesos.interface.egg
     rm mesos.interface.egg
fi

if [ $(python -c "import mesos.native";echo $?) -ne 0 ]; then
     wget -O mesos.egg http://downloads.mesosphere.io/master/ubuntu/14.04/mesos-0.24.0-py2.7-linux-x86_64.egg >/dev/null 2>&1
     sudo easy_install mesos.egg
     rm mesos.egg
fi

