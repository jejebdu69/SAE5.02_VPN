#!/bin/bash
set -e
ipsec start
service strongswan-starter start
tail -f /var/log/syslog
