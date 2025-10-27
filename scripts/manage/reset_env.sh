#!/usr/bin/env bash
set -e
sudo systemctl stop strongswan-starter || true
sudo rm -f /etc/ipsec.conf /etc/ipsec.secrets
sudo rm -rf /etc/ipsec.d
sudo rm -rf /var/log/strongswan
echo "Environment reset."
