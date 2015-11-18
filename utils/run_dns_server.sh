#!/bin/sh

# to call docker proxy should be disabled
export http_proxy=""
export HTTP_PROXY=""

# docker must be installed to perform this operation
# we have to use absolute path cause docker doesn't allow to use relative versions dues to security issues
# it's as`sumed that the working directory will be root of the OVERALL project
path_to_althosts=$(pwd)"/utils/althosts"
ip_address=192.168.13.132
docker run -d -p $ip_address:53:53/tcp -p $ip_address:53:53/udp --cap-add=NET_ADMIN -v "$path_to_althosts":/etc/althosts devries/dnsmasq
