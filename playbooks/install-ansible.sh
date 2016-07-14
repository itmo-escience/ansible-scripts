#!/usr/bin/env bash

if [[ -f /etc/redhat-release ]] 
then
  OS=RedHat
else
  OS=Debian
fi

if [[ $OS = Debian ]] 
then
	ansible_status=$(dpkg -s ansible | grep Status)
	if [[ $ansible_status == *"ok"* ]]
	then
		echo "Ansible already installed"
		dpkg-query -W -f='${Status} ${Version}\n' ansible
	else
		add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
		apt-get install -y software-properties-common
		apt-add-repository -y ppa:ansible/ansible
		repo_dir=/etc/apt/sources.list.d
		ansible_repo=$(ls $repo_dir | grep -m 1 "^ansible")
		#apt-get update -o Dir::Etc::sourcelist=$repo_dir/$ansible_repo
		apt-get update && apt-get install -y ansible
	fi
else
	rpm -q ansible
	if [[ $? -ne 0 ]]
	then
	    sudo yum install -y wget
		wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
        sudo rpm -ivh epel-release-7-5.noarch.rpm
		sudo yum -y update
		sudo yum -y install ansible --enablerepo=epel-testing
	else
		echo "Ansible already installed"
	fi
fi