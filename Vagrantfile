require 'yaml'
require 'vagrant-disksize'

nodes = YAML.load_file('configuration.yaml')['nodes']

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node['name'] do |vm|
      vm.disksize.size = node['disk_size'] if node['disk_size']
      vm.vm.box = node['image']
      vm.vm.hostname = node['hostname']
      vm.vm.network "private_network", ip: node['ip']
      vm.vm.provider "virtualbox" do |vb|
        vb.cpus = node['cpus']
        vb.memory = node['memory']
      end
      if node['env']
        node['env'].each do |env_var|
          vm.vm.provision "shell", inline: "echo 'export #{env_var['name']}=#{env_var['value']}' >> /etc/profile.d/custom_env.sh"
        end
      end
      if node['script']
        script_parts = node['script'].split(' ')
        script_path = script_parts.shift
        vm.vm.provision "shell",
          path: script_path,
          args: script_parts
      end
    end
  end
end