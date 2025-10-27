# Vagrantfile - VM Ubuntu 24.04 pour VPN StrongSwan

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Box Ubuntu 24.04
  config.vm.box = "bento/ubuntu-24.04"  # Ubuntu 24.04 (generic, supports libvirt)

  # Nom de la VM
  config.vm.hostname = "vpn01"

  # Réseau : IP fixe pour Ansible
  config.vm.network "private_network", ip: "192.168.56.10"

  # Configuration SSH (par défaut Vagrant)
  config.ssh.username = "vagrant"
  config.ssh.insert_key = true

  # Ressources (optionnel)
  config.vm.provider "virtualbox" do |vb|
    vb.name = "vpn01"
    vb.memory = "2048"
    vb.cpus = 2
  end

  # Provisionner la VM pour installer SSH et utilitaires de base
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y openssh-server build-essential unzip curl wget vim ufw iproute2
    sudo systemctl enable ssh
    sudo ufw allow 22
  SHELL
end
