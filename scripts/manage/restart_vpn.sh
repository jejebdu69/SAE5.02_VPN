#!/usr/bin/env bash
set -e
sudo systemctl restart strongswan-starter
sudo ipsec statusall || true
echo "VPN redémarré"