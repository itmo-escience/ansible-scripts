# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # for building we use the same files as for the regular run
  config.ssh.forward_agent = true
  config.ssh.insert_key = false
  config.vm.synced_folder Dir.getwd, "/home/vagrant/ansible-mesos-playbook"
	
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://proxy.ifmo.ru:3128/"
    config.proxy.no_proxy = "localhost,127.0.0.1,"
  end

  # read data for vagrant run
  nds = File.open("hosts","r") do |hosts|
	nodes = {}
	while(line = hosts.gets) do
		if line.start_with?("###")
			break
		end
		strs = line.strip().split(" ")
		params = {}
		for s in strs[1..-1] do
			pair = s.split("=")
			params[pair[0]]=pair[1]
		end
		nodes[strs[0]] = params
	end
	nodes
  end

  # ubuntu
  nds.keys.sort.each.map do |name|
    ip = nds[name]["ansible_ssh_host"]

    config.vm.define name, primary: true do |c|
      c.vm.network "public_network", ip: ip, netmask: "255.255.0.0"
      #c.vm.box = "build/mesos-ubuntu"
      #c.vm.box = "ubuntu/trusty64"
      c.vm.box = "ubuntu-trusty64"
      #c.vm.hostname = name
      c.vm.provision "shell" do |s|
        dns_server = "if ! grep -q \'nameserver 192.168.13.132\' /etc/resolvconf/resolv.conf.d/head; then echo 'nameserver 192.168.13.132'|tee --append /etc/resolvconf/resolv.conf.d/head; fi;resolvconf -u;"
	default_iface = "ip route change to default dev eth1;"
	hosts_file = "echo '127.0.0.1 localhost'|tee /etc/hosts;echo '#{ip} #{name}'|tee --append /etc/hosts;"
	#dns_server = ""
	s.inline = "#{hosts_file}#{dns_server}#{default_iface}apt-add-repository ppa:ansible/ansible -y; apt-get update -y; apt-get install ansible -y;"
        s.privileged = true
      end
      c.vm.provider :virtualbox do |vb|
	#vb.customize ["modifyvm", :id, "--memory", 8129]
	#vb.customize ["modifyvm", :id, "--cpus", "2"]
      	vb.memory = 8192
	vb.cpus = 2
      end
      c.vm.synced_folder "hdfs_data/data_#{name}", "/hdfs_data", create: true, mount_options: ["dmode=777,fmode=777"]
      #c.vm.provision "ansible" do |ansible|
      #    ansible.playbook = "playbook.yml"
      #    ansible.inventory_path="hosts"
      #    ansible.verbose = "vvvv"
      #end
    end
  end
end
