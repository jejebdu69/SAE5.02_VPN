FROM ubuntu:24.04
RUN apt-get update && apt-get install -y strongswan iproute2 && rm -rf /var/lib/apt/lists/*
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
VOLUME ["/etc/ipsec.d", "/var/log/strongswan"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
