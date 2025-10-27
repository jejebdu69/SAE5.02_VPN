#!/usr/bin/env bash
set -e
mkdir -p ca certs private reqs
[ ! -f ca/cakey.pem ] && openssl genrsa -out ca/cakey.pem 4096
[ ! -f ca/cacert.pem ] && openssl req -x509 -new -nodes -key ca/cakey.pem -sha256 -days 3650 -out ca/cacert.pem -subj "/C=FR/ST=France/L=Lyon/O=VPNTest/OU=Lab/CN=VPN-CA"
[ ! -f private/serverKey.pem ] && openssl genrsa -out private/serverKey.pem 4096
openssl req -new -key private/serverKey.pem -out reqs/serverReq.csr -subj "/C=FR/ST=France/L=Lyon/O=VPNTest/OU=Server/CN=vpn-server"
openssl x509 -req -in reqs/serverReq.csr -CA ca/cacert.pem -CAkey ca/cakey.pem -CAcreateserial -out certs/serverCert.pem -days 825 -sha256
echo "OK - Certificats générés sous /work"
