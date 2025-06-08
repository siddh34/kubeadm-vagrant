# Vagrant Kubeadm Setup

This project sets up virtual machines using Vagrant + VirtualBox. It can be setup in ubuntu os currently later support will be added for arch and other linux

Before starting, Install disk_size plugin for vagrant:

```bash
vagrant plugin install vagrant-disksize
```

## Virtual Machines Configuration based k8s config

1. **VM1**: 
   - CPUs: 2
   - RAM: 4 GB
   - disk: 20 GB

2. **VM2**: 
   - CPUs: 1
   - RAM: 2 GB
   - disk: 12 GB

## Getting Started

### Prerequisites

- Install [Vagrant](https://www.vagrantup.com/downloads)
- Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

### Setup

1. Clone this repository or download the project files.
2. Navigate to the project directory:
   ```
   cd vagrant-project
   ```
3. Start the virtual machines:
   ```
   vagrant up
   ```

### Accessing the Virtual Machines

- To SSH into VM1:
  ```
  vagrant ssh {machine_name}
  ```

### Stopping the Virtual Machines

To stop the virtual machines, run:
```
vagrant halt
```

### Destroying the Virtual Machines

To remove the virtual machines, run:
```
vagrant destroy
```

## Starting using kubectl from local

```bash
export KUBECONFIG=$(pwd)/.kube/config
```