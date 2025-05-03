# Vagrant Kubeadm Manual Setup

This project sets up two virtual machines using Vagrant + VirtualBox. 

## Virtual Machines Configuration

1. **VM1**: 
   - CPUs: 2
   - RAM: 4 GB

2. **VM2**: 
   - CPUs: 1
   - RAM: 2 GB

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
  vagrant ssh vm1
  ```

- To SSH into VM2:
  ```
  vagrant ssh vm2
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