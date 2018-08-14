#!/bin/bash -xe

if [ ! -e ./vagrant.key ];
then
    /usr/bin/ssh-keygen -C vagrant -N "" -f ./vagrant.key
fi

for i in {1..3}; do
    sshpass -p 'vagrant' \
		ssh-copy-id \
        -o LogLevel=QUIET \
		-o StrictHostKeyChecking=no \
		-o UserKnownHostsFile=/dev/null \
		-i ./vagrant.key vagrant@192.168.56.10${i};
done
