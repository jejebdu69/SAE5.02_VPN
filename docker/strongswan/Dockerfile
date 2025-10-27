FROM ubuntu:24.04
RUN apt-get update && apt-get install -y strongswan iproute2
COPY entrypoint.sh /usr/local/bin/
COPY configs/ /etc/ipsec.d/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
