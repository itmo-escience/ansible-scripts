#!/usr/bin/env bash

set -e

# install proxy
echo 'export http_proxy=http://proxy.ifmo.ru:3128' >> ~/.bashrc
echo 'export HTTP_PROXY=http://proxy.ifmo.ru:3128' >> ~/.bashrc

# get git
sudo http_proxy=http://proxy.ifmo.ru:3128 HTTP_PROXY=http://proxy.ifmo.ru:3128 apt-get install -y git

export http_proxy=http://proxy.ifmo.ru:3128 
export HTTP_PROXY=http://proxy.ifmo.ru:3128

# get maven
wget http://apache-mirror.rbc.ru/pub/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz
tar -xzf apache-maven-3.3.9-bin.tar.gz
echo 'export MVN=/home/vagrant/apache-maven-3.3.9/bin/mvn' >> ~/.bashrc

# get lein
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod a+x lein
echo 'export LEIN=/home/vagrant/lein' >> ~/.bashrc