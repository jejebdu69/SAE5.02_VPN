#!/usr/bin/env bash
set -e
mkdir -p certificates/ca certificates/server
[ ! -f certificates/ca/cakey.pem ] && openssl genrsa -out certificates/ca/cakey.pem 4096
[ ! -f certificates/ca/cacert.pem ] && openssl req -x509 -new -nodes -key certificates/ca/cakey.pem -sha256 -days 3650 -out certificates/ca/cacert.pem -subj "/C=FR/ST=France/L=Lyon/O=VPNTest/OU=Lab/CN=VPN-CA"
[ ! -f certificates/server/serverKey.pem ] && openssl genrsa -out certificates/server/serverKey.pem 4096
openssl req -new -key certificates/server/serverKey.pem -out certificates/server/serverReq.csr -subj "/C=FR/ST=France/L=Lyon/O=VPNTest/OU=Server/CN=vpn-server"
openssl x509 -req -in certificates/server/serverReq.csr -CA certificates/ca/cacert.pem -CAkey certificates/ca/cakey.pem -CAcreateserial -out certificates/server/serverCert.pem -days 825 -sha256
sudo cp certificates/ca/cacert.pem /etc/ipsec.d/cacerts/cacert.pem
sudo cp certificates/server/serverCert.pem /etc/ipsec.d/certs/serverCert.pem
sudo cp certificates/server/serverKey.pem /etc/ipsec.d/private/serverKey.pem
echo "OK - certificats générés et installés"