# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  project_dir = "/vagrant"

  # for building we use the same files as for the regular run
  config.ssh.forward_agent = true
  config.ssh.insert_key = false

  config.vm.box_url = "http://192.168.1.36/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.synced_folder ".", project_dir, :mount_options => ["dmode=700","fmode=600"]
	
  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://proxy.ifmo.ru:3128/"
    config.proxy.no_proxy = "localhost,127.0.0.1,192.168.1.36"
   else
    raise 'ProxyConf plugin not installed!'
  end

  # read data for vagrant run
  nds = File.open("./ansible-bdas/storm-12.hosts","r") do |hosts|
	nodes = {}
	while(line = hosts.gets) do
			
		if line.start_with?("###")
			break
		end

		if not line.start_with?("#")
			strs = line.strip().split(" ")
			params = {}
			for s in strs[1..-1] do
				pair = s.split("=")
				params[pair[0]]=pair[1]		
			end
			nodes[strs[0]] = params
		end
	end
	nodes
  end

  # ubuntu
  nds.keys.sort.each.map do |name|
    ip = nds[name]["ansible_ssh_host"]

    config.vm.define name, primary: true do |c|
      #c.vm.network "public_network", ip: ip, netmask: "255.255.255.0"
      c.vm.network "public_network", ip: ip, netmask: "255.255.0.0", bridge: "enp22s0f5"


      #c.vm.box = "build/mesos-ubuntu"
      c.vm.box = "ubuntu/trusty64"
      #c.vm.box = "ubuntu-trusty64"
      c.vm.hostname = name
    c.vm.provision "shell" do |s|
        dns_server = "if ! grep -q \'nameserver 192.168.13.132\' /etc/resolvconf/resolv.conf.d/head; then echo 'nameserver 192.168.13.132'|tee --append /etc/resolvconf/resolv.conf.d/head; fi;resolvconf -u;"
        hosts_file = "echo '127.0.0.1 localhost'|tee /etc/hosts;echo '#{ip} #{name}'|tee --append /etc/hosts;"
        s.inline = "#{hosts_file}#{dns_server}"
		s.privileged = true
    end

      #c.vm.provision "shell", path: "install-mesos-python-binding.sh"
      c.vm.provision "shell", path: "install-sshkey.sh", args: project_dir
	  c.vm.provision "shell", inline: "export http_proxy='http://proxy.ifmo.ru:3128'", privileged: true
	  c.vm.provision "shell", inline: "export HTTP_PROXY='http://proxy.ifmo.ru:3128'", privileged: true
	  c.vm.provision "shell", inline: "export no_proxy='localhost,127.0.0.1,192.168.1.36'", privileged: true
	  
      c.vm.provider :virtualbox do |vb|
      	vb.cpus = nds[name]["cpus"]
	vb.memory = nds[name]["memory"]	    
      end

      #c.vm.synced_folder "hdfs_data/data_#{name}", "/hdfs_data", create: true, mount_options: ["dmode=777,fmode=777"]

    end
  end
end

