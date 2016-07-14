docker run -d -v /home/nano/wspace/althosts:/etc/althosts -p 53:53/tcp -p 53:53/udp --cap-add=NET_ADMIN devries/dnsmasq
