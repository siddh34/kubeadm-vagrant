Vagrant.configure("2") do |config|
  # Define VM1
  config.vm.define "vm1" do |vm1|
    vm1.vm.box = "net9/ubuntu-24.04-arm64"
    vm1.vm.network "forwarded_port", guest: 80, host: 8080
    vm1.vm.provider "virtualbox" do |vb|
      vb.cpus = 2
      vb.memory = 4096
    end
  end

  # TODO: Networking between VMs

  # Define VM2
  # config.vm.define "vm2" do |vm2|
  #   vm2.vm.box = "net9/ubuntu-24.04-arm64"
  #   vm2.vm.network "forwarded_port", guest: 80, host: 8081
  #   vm2.vm.provider "virtualbox" do |vb|
  #     vb.cpus = 1
  #     vb.memory = 2048
  #   end
  # end
end