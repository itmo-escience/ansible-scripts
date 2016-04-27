# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

Vagrant.configure("2") do |config|

  project_dir = "/home/vagrant/project"

  config.ssh.forward_agent = true
  config.ssh.insert_key = false

  config.vm.synced_folder ".", project_dir, :mount_options => ["dmode=700","fmode=600"]

  proxy = if ENV.has_key?("HTTP_PROXY")
                ENV["HTTP_PROXY"]
                elsif ENV.has_key?("http_proxy")
                ENV["http_proxy"]
                end

  if Vagrant.has_plugin?("vagrant-proxyconf") && ( proxy != nil && !proxy.empty? )
     config.proxy.http     = proxy
     config.proxy.no_proxy = "localhost,127.0.0.1,192.168."
  end

  vms = YAML.load_file('settings.yml')['vms']

  # ubuntu
  vms.each do |vm|
    ip = vm['ip']
    hostname = vm['hostname']
    hdfs_volume = vm['hdfs_volume']

    config.vm.define hostname, primary: true do |c|
      c.vm.network "public_network", ip: ip, netmask: "255.255.0.0", bridge: "enp7s0f0"
      c.vm.box = "ubuntu/trusty64"
      c.vm.hostname = hostname

      c.vm.provision "shell" do |s|
         dns_server = "if ! grep -q \'nameserver 192.168.13.132\' /etc/resolvconf/resolv.conf.d/head; then echo 'nameserver 192.168.13.132'|tee --append /etc/resolvconf/resolv.conf.d/head; fi;resolvconf -u;"
         hosts_file = "echo '127.0.0.1 localhost'|tee /etc/hosts;echo '#{ip} #{hostname}'|tee --append /etc/hosts;"
         s.inline = "#{hosts_file}#{dns_server}"
         s.privileged = true
      end

      c.vm.provision "shell", path: "install-sshkey.sh", args: project_dir

      c.vm.provider :virtualbox do |vb|
      	vb.memory = 45000
	    vb.cpus = 8
      end

      c.vm.synced_folder "#{hdfs_volume}", "/hdfs_data", create: true, mount_options: ["dmode=777,fmode=777"]

    end

  end

end