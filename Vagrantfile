# Vagrantfile : Serveur VPN (vpn01) + Client VPN (client01)
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # --- Configuration commune ---
  config.vm.box = "bento/ubuntu-24.04"
  config.ssh.insert_key = true

  # --- Serveur VPN ---
  config.vm.define "vpn01" do |vpn|
    vpn.vm.hostname = "vpn01"
    vpn.vm.network "private_network", ip: "192.168.56.10"

    vpn.vm.provider "virtualbox" do |vb|
      vb.name = "vpn01"
      vb.memory = 2048
      vb.cpus = 2
    end

    vpn.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install -y openssh-server ufw curl unzip vim build-essential iproute2 ansible
      sudo ufw allow 22
      sudo systemctl enable ssh
    SHELL
  end

  # --- Client VPN ---
  config.vm.define "client01" do |client|
    client.vm.hostname = "client01"
    client.vm.network "private_network", ip: "192.168.56.11"

    client.vm.provider "virtualbox" do |vb|
      vb.name = "client01"
      vb.memory = 1024
      vb.cpus = 1
    end

    client.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install -y strongswan strongswan-pki openssl vim iputils-ping net-tools
      sudo systemctl enable strongswan-starter
    SHELL
  end
end
