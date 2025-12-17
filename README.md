# 🛡️ SAE 5.02 — Laboratoire VPN StrongSwan automatisé

Ce projet met en place un **environnement de test complet pour VPN IPsec/IKEv2** basé sur **StrongSwan**, permettant d’expérimenter et comparer trois modes d’authentification :

* **PSK** — Pre-Shared Key
* **RSA** — Certificats
* **EAP-MSCHAPv2** — Identifiant / mot de passe

L’ensemble du laboratoire est automatisé grâce à **Docker**, **Vagrant**, **Ansible**, et plusieurs scripts Bash.

Deux machines virtuelles sont utilisées :

* **vpn01** — Serveur StrongSwan
* **client01** — Client StrongSwan

Cet environnement permet de tester rapidement différentes configurations, d’analyser les échanges IKE et de comparer les méthodes d’authentification.

---

# 🏗️ Architecture du laboratoire

```
[ Client StrongSwan ]  ⇄  [ Serveur StrongSwan ]
        client01                   vpn01
```

* VM créées automatiquement avec Vagrant ou Docker
* Configuration réseau, firewall, certificats et StrongSwan appliqués via Ansible
* Possibilité de reconfigurer à chaud un mode VPN sans recréer les machines

---

# 📦 Modes VPN supportés

## 🔑 PSK (Pre-Shared Key)

* Partage d’une clé dans `ipsec.secrets`
* Simple et rapide à mettre en place
* Moins sécurisé que les autres modes

## 🔐 RSA (Certificats)

* CA locale générée automatiquement
* Certificats serveur + client
* Mode le plus sécurisé du lab
* ICS/IKEv2 standard

## 👤 EAP-MSCHAPv2

* Login + mot de passe
* Nécessite un certificat uniquement côté serveur
* Le client peut être compatible Windows, Linux, Android

Chaque mode possède ses propres templates Jinja et tâches Ansible, se substituant dynamiquement lors du choix dans le menu.

---

# 📂 Structure du projet

```
SAE5.02_VPN/
├── Vagrantfile		  # Déploiement VM Vagrant
├── config_menu.sh        # Menu principal interactif
├── ansible/
│   ├── inventory/
│   ├── playbooks/        # Déploiement serveur & client
│   └── roles/            # strongswan, client, openssl, network
│       └── client/
│       └── network/
│       └── openssl/
│       └── strongswan/
│   └── docker/           # Déploiement image Dockerfile 
│       └── client/
│       └── strongswan/
└── scripts/
    └── manage/           # start, stop, reset, destroy (Vagrant & Docker)
```

---

# 🧭 Menu principal — `config_menu.sh`

Le fichier **`config_menu.sh`** est le point d’entrée du laboratoire.
Il propose un menu interactif permettant de :

```
1  Configurer mode : PSK
2  Configurer mode : RSA
3  Configurer mode : MSCHAPv2
4  Supprimer le lab Vagrant (destroy_lab.sh)
5  Démarrer le lab Vagrant (start_lab.sh)
6  Supprimer le lab Docker (destroy_lab_docker.sh)
7  Démarrer le lab Docker (start_lab_docker.sh)
8  Quitter
```

---

# ⚙️ Fonctionnement du menu

## 🟦 1 / 2 / 3 — Configurer un mode VPN (PSK / RSA / MSCHAPv2)

Lorsqu’un mode est sélectionné :

* **Seuls les fichiers YAML sont modifiés** pour définir le mode (`mode_auth`) côté serveur et client :

```
ansible/roles/strongswan/vars/main.yml
ansible/roles/client/vars/main.yml
```

* Aucun déploiement Vagrant ou Ansible n’est effectué automatiquement à ce stade.

> **Note :** Les modifications seront prises en compte lorsque le lab sera démarré via l’option `5` (Vagrant) ou `7` (Docker).

---

## 🧹 4 — Supprimer complètement le laboratoire Vagrant

```
scripts/manage/destroy_lab.sh
```

Ce script :

* détruit les VM (`vagrant destroy -f`)
* supprime certificats, configs et fichiers générés
* remet le dépôt dans un état propre

---

## 🟢 5 — Démarrer le laboratoire Vagrant

* Lance les machines Vagrant :

```
vagrant up
```

* Déploie ensuite le VPN sur serveur et client via Ansible playbooks :

```
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy_vpn.yml
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy_client.yml
```

---

## 🧹 6 — Supprimer le laboratoire Docker

```
scripts/manage/destroy_lab_docker.sh
```

* Supprime les conteneurs et configurations Docker
* Remet l’environnement Docker dans un état propre

---

## 🔴 7 — Démarrer le laboratoire Docker

* Lance l’environnement Docker
* Déploie le VPN via les playbooks avec l’inventaire Docker :

```
ansible-playbook -i ansible/inventory/hosts_docker.ini ansible/playbooks/deploy_vpn.yml
ansible-playbook -i ansible/inventory/hosts_docker.ini ansible/playbooks/deploy_client.yml
```

---

## 🔴 8 — Quitter le menu

Ferme le menu et quitte le script.

---

# ▶️ Guide rapide d’utilisation

### 1. Lancer le menu principal

```bash
./config_menu.sh
```

### 2. Choisir un mode VPN ou une action Docker/Vagrant

Exemple : `1` pour configurer le mode PSK, `5` pour démarrer Vagrant, ou `7` pour Docker.

### 3. Attendre la configuration automatique

* Pour Vagrant : playbooks appliqués automatiquement après `vagrant up`.
* Pour Docker : playbooks appliqués automatiquement lors du démarrage du lab Docker.

### 4. Tester la connexion depuis le client Vagrant

```
vagrant ssh client01
sudo ipsec up vpn
sudo ipsec status
```

### 5. Tester la connexion depuis le client Docker

```
docker exec -it client01 bash
ipsec up vpn
ipsec status
```

---

# 🧪 Objectif pédagogique

Ce projet permet :

* de comprendre les mécanismes d’IKEv2 / IPsec
* de comparer trois méthodes d’authentification
* d’analyser les échanges via les logs StrongSwan
* de déployer un environnement reproductible
* d’automatiser entièrement les configurations avancées

Il constitue un outil de test robuste pour la cybersécurité réseau.

---
