#!/bin/bash -xe
if [ ! -e /usr/local/bin/bolt ];
then
    echo "# Installing bolt (requires Ruby Gem to be installed)"
    which gem || (echo "Couldn't find gem.  Is it installed?" && return 1)
    gem install bolt
fi

echo -n "# Checking bolt installation: "
which bolt || (echo "Couldn't find bolt! Is it installed?" && return 2)

echo -n "# Checking bolt version: "
bolt --version || (echo "Coudln't find bolt! Is it installed?" && return 3)

echo
echo "# First bolt command; One node"
echo "# Enter password 'vagrant' (no quotes) when prompted!"
set -x
bolt --user vagrant --password --nodes 192.168.56.101 --no-host-key-check command run 'hostname && uptime'
set +x

echo
echo "# Second bolt command; Multiple nodes"
echo "# Enter password 'vagrant' (no quotes) when prompted!"
set -x
bolt --user vagrant --password --nodes 192.168.56.101,192.168.56.102,192.168.56.103 --no-host-key-check command run 'hostname && uptime'
set +x

echo
echo "# Creating and inserting a key pair for remaining commands..."
read -rsn1 -p"Press any key to continue";echo
source ./make_ssh_key.sh > /dev/null

echo
echo "# Third bolt command; Run bolt with a key instead of a password"
set -x
bolt --private-key ./vagrant.key --user vagrant --nodes 192.168.56.101,192.168.56.102,192.168.56.103 --no-host-key-check command run 'hostname && uptime'
set +x

echo "# Third bolt command; Run bolt with a key and inventory file"
set -x
bolt --inventoryfile ./inventory.yml --nodes targets command run 'hostname && uptime'
set +x
