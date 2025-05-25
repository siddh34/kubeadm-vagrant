require 'yaml'

nodes = YAML.load_file('configuration.yaml')['nodes']

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node['name'] do |vm|
      vm.vm.box = node['image']
      vm.vm.hostname = node['hostname']
      vm.vm.network "private_network", ip: node['ip']
      vm.vm.provider "virtualbox" do |vb|
        vb.cpus = node['cpus']
        vb.memory = node['memory']
      end
      vm.vm.provision "shell", path: node['script'] if node['script']
    end
  end
end