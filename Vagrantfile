# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"

servers = {
    'target01' => {
        name:'Target Server 01',
        cpus:'1',
        guest_port:'80',
        host_port:'18081',
        ip:'192.168.56.101',
        memory:'1024'
    },

    'target02'    => {
        name:'Target Server 2',
        cpus:'1',
        guest_port:'80',
        host_port:'18082',
        ip:'192.168.56.102',
        memory:'1024'
    },

    'target03'    => {
        name:'Target Server 3',
        cpus:'1',
        guest_port:'80',
        host_port:'18083',
        ip:'192.168.56.103',
        memory:'1024'
    },
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "bento/ubuntu-18.04"
    config.vm.box_version = "201807.12.0"

    servers.each do |hostname, settings|
        config.vm.define hostname do |host|
            host.vm.hostname = "#{hostname}.local"
            host.vm.network "private_network", ip: settings[:ip]
            host.vm.network "forwarded_port", guest: settings[:guest_port], host: settings[:host_port]

            host.vm.provider "virtualbox" do |v|
                v.memory = settings[:memory]
                v.cpus   = settings[:cpus]
                v.name   = settings[:name]
            end
            host.vm.provision "shell", path: "provision.sh"
        end

    end
end
