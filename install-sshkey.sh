#!/bin/sh

PATH_TO_PROJECT=$1

if [ ! -f ~/.ssh/id_rsa_vagrant.pub ]; then
    cp $PATH_TO_PROJECT/sshkey/id_rsa.pub /home/vagrant/.ssh/id_rsa_vagrant.pub;
    cat $PATH_TO_PROJECT/sshkey/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
    echo 'The key from sshkey has been succesfully installed'
else
    echo 'The key from sshkey is already installed'
fi
