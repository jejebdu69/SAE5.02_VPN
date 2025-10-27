#!/usr/bin/env bash
set -e
sudo cp ./configs/strongswan.conf.example /etc/strongswan.conf
sudo cp ./configs/ipsec.conf.example /etc/ipsec.conf
sudo cp ./configs/ipsec.secrets.example /etc/ipsec.secrets
sudo mkdir -p /etc/ipsec.d/{private,certs,cacerts}
sudo systemctl enable --now strongswan-starter
echo "OK - strongSwan configuré"