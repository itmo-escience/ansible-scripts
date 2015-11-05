#!/bin/sh

# to call docker proxy should be disabled
export http_proxy=""
export HTTP_PROXY=""

# docker must be installed to perform this operation
# we have to use absolute path cause docker doesn't allow to use relative versions dues to security issues
# it's as`sumed that the working directory will be root of the OVERALL project
path_to_althosts=$(pwd)"/utils/althosts"
ip_address=127.0.0.1
docker run -d -p 53:53 -v "$path_to_althosts":/etc/althosts devries/dnsmasq