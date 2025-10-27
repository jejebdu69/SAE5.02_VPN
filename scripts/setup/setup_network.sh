#!/usr/bin/env bash
set -e
sudo sysctl -w net.ipv4.ip_forward=1
sudo ufw allow 500/udp || true
sudo ufw allow 4500/udp || true
sudo iptables -t nat -C POSTROUTING -s 10.10.0.0/24 -o eth0 -j MASQUERADE || sudo iptables -t nat -A POSTROUTING -s 10.10.0.0/24 -o eth0 -j MASQUERADE
echo "OK - Network setup completed"