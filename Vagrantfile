Vagrant.configure("2") do |config|
  config.vm.define "vm1" do |master|
    master.vm.box = "net9/ubuntu-24.04-arm64"
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.56.101"
    master.vm.provider "virtualbox" do |vb|
      vb.cpus = 2
      vb.memory = 4096
    end
  end

  config.vm.define "vm2" do |worker|
    worker.vm.box = "net9/ubuntu-24.04-arm64"
    worker.vm.network "private_network", ip: "192.168.56.102"
    worker.vm.hostname = "worker1"
    worker.vm.provider "virtualbox" do |vb|
      vb.cpus = 1
      vb.memory = 2048
    end
  end
end