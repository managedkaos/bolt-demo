# Bolt Demo

Bolt is a Ruby command-line tool for executing commands, scripts, and tasks on remote systems using SSH and WinRM.

This demo focuses on running commands and scripts on Ubuntu servers via SSH.

Your system needs to have the following software installed:

- <a href="https://www.virtualbox.org/" target="_blank">Virtualbox</a>
- <a href="https://www.vagrantup.com/" target="_blank">Vagrant</a>
- <a href="https://www.ruby-lang.org/" target="_blank">Ruby Gem</a>

# Install Bolt

    gem install bolt
    which bolt
    bolt --version

# Start the target servers

    vagrant up

# Run a command on the target servers; connect via username and password

    bolt --user vagrant --password --nodes 192.168.56.101 --no-host-key-check command run 'hostname && uptime'

    bolt --user vagrant --password --nodes 192.168.56.101,192.168.56.102,192.168.56.103 --no-host-key-check command run 'hostname && uptime'

# Create key pair and add public key to the authorized_users file on each target

    /usr/bin/ssh-keygen -C vagrant -N "" -f ./vagrant.key

    for i in {1..3}; do
        sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ./vagrant.key vagrant@192.168.56.10${i};
    done

# Run bolt with the key instead of a password

     bolt --private-key ./vagrant.key --user vagrant --nodes 192.168.56.101,192.168.56.102,192.168.56.103 --no-host-key-check command run 'hostname && uptime'

# Create an inventory file with groups and configuration

     vim inventory.yml

```
groups:
  - name: targets
    nodes:
      - 192.168.56.101
      - 192.168.56.102
      - 192.168.56.103
    config:
      ssh:
        user: vagrant
        private-key: ./vagrant.key
        host-key-check: false
```
# Run bolt with inventory file

    bolt --inventoryfile ./inventory.yml --nodes targets command run 'hostname && uptime'

# Bounty for Helping Improve Bolt

"Earn $50 by helping us evaluate your experience with Bolt. If you’re working with Bolt right now, take a few moments to tell us how it goes."

1. Share your email address: https://www.surveygizmo.com/s3/4219588/1e35b32fc989

2. Complete a user journal (make a copy of this document):  https://docs.google.com/document/d/1bBxGQ06oVxDdvrbLh9ErpULjx65Ic1H7Ee_nIEHoHcE/edit?usp=sharing

3. Share your copy of the document with testpilots@puppet.com to get a $50 Amazon gift card.
