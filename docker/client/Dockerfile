FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Installer systemd et dépendances
RUN apt-get update && apt-get install -y \
    systemd \
    dbus \
    sudo \
    openssh-server \
    strongswan \
    python3 \
    python3-apt \
    iproute2 \
    iptables \
    net-tools \
    tcpdump \
    && rm -rf /var/lib/apt/lists/*

# Créer l'utilisateur ansible
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Autoriser SSH
RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
 && echo "AuthorizedKeysFile /home/ansible/.ssh/authorized_keys" >> /etc/ssh/sshd_config

# Dossier SSH
RUN mkdir -p /run/sshd /home/ansible/.ssh && chown ansible:ansible /home/ansible/.ssh

# Copier entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 22

# Activer systemd
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
