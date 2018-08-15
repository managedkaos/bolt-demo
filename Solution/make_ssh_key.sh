#!/bin/bash -xe

if [ ! -e ./vagrant.key ];
then
    /usr/bin/ssh-keygen -C vagrant -N "" -f ./vagrant.key
fi

#echo -n "Enter the server password (press ENTER for default): "
#read -s password
#echo

password="${password:-vagrant}"

for i in {1..3}; do
    sshpass -p "$password" \
		ssh-copy-id \
        -o LogLevel=QUIET \
		-o StrictHostKeyChecking=no \
		-o UserKnownHostsFile=/dev/null \
		-i ./vagrant.key vagrant@192.168.56.10${i};
done
