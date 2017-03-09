# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.box = "centos/7"
  
  config.vm.define "EnvoyBuilder" do |node|
    node.vm.provision "shell", path: "scripts/bootstrap.sh"
    #node.vm.provision "shell", path: "scripts/setup_tools.sh"
    node.vm.provider "virtualbox" do |vb|
        vb.name   = "EnvoyBuilder"
        vb.memory = 2048 
        vb.cpus   = 2
    end
  end

  #Vagrant Cachier
  if Vagrant.has_plugin?("vagrant-cachier")
    # http://fgrehm.viewdocs.io/vagrant-cachier/usage/
    config.cache.scope="box"
    config.cache.enable :yum
  end

  #Vagrant vb-guest
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = true
    config.cache.enable :yum
    config.vbguest.no_remote = true
  end

end
