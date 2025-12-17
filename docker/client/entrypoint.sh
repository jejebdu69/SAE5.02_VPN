#!/bin/bash
set -e

mkdir -p /home/ansible/.ssh
chown ansible:ansible /home/ansible/.ssh
chmod 700 /home/ansible/.ssh

# Attendre que authorized_keys existe et ne soit pas vide
while [ ! -s /home/ansible/.ssh/authorized_keys ]; do
    echo "Waiting for authorized_keys..."
    sleep 1
done

chown ansible:ansible /home/ansible/.ssh/authorized_keys
chmod 600 /home/ansible/.ssh/authorized_keys

# Génération des clés host SSH
ssh-keygen -A

# Lancer SSH
exec /usr/sbin/sshd -D
