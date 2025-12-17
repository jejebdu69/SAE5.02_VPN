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

Le client peut etre compatible Windows, Linux, Android

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
│   │   └── client/
│   │   └── network/
│   │   └── openssl/
│   │   └── strongswan/
│   └── docker /	  # Déploiement image Dockerfile 
│   │   └── client/
│   │   └── strongswan/
└── scripts/
    └── manage/           # start, stop, reset, destroy
```

---

# 🧭 Menu principal — `config_menu.sh`

Le fichier **`config_menu.sh`** est le point d’entrée du laboratoire.
Il propose un menu interactif permettant de :

```
1  Configurer mode : PSK
2  Configurer mode : RSA
3  Configurer mode : MSCHAPv2
4  Supprimer le lab (destroy_lab.sh)
5  Allumer les machines (vagrant up)
6  Éteindre les machines (vagrant halt)
```

---

# ⚙️ Fonctionnement du menu

## 🟦 1 / 2 / 3 — Configurer un mode VPN (PSK / RSA / MSCHAPv2)

Lorsqu’un mode est sélectionné :

### ✔️ 1. Les machines sont créées si elles n’existent pas

Le script lance automatiquement :

```
vagrant up
```

>**Note :** Si les machines n'existe pas elle vont être crées

Ensuite les playbooks sont lancé sur chaque machines 

```
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy_vpn.yml
```
```
ansible-playbook -i ansible/inventory/hosts.ini ansible/playbooks/deploy_client.yml
```

### ✔️ 2. Les certificats et secrets sont générés

Selon le mode :

* RSA → CA + cert client/serveur
* PSK → clé partagée
* EAP → user/password + cert serveur

### ✔️ 3. Les fichiers StrongSwan sont générés dynamiquement

* ipsec.conf
* ipsec.secrets
* strongswan.conf

Les templates correspondants sont rendus via Ansible.

### ✔️ 4. Ansible configure les deux machines

* installation StrongSwan
* règles réseau / NAT
* déploiement des certificats
* configuration du serveur et du client
* redémarrage du service

### ✔️ 5. Le mode est immédiatement opérationnel

Sans recréer l’environnement complet.

---

## 🧹 4 — Supprimer complètement le laboratoire

Lance :

```
scripts/manage/destroy_lab.sh
```

Ce script :

* détruit les VM (`vagrant destroy -f`)
* supprime certificats, configs et fichiers générés
* remet le dépôt dans un état propre

---

## 🟢 5 — Allumer les machines

Equivalent à :

```
vagrant up
```

---

## 🔴 6 — Éteindre les machines

Equivalent à :

```
vagrant halt
```

---

# ▶️ Guide rapide d’utilisation

### 1. Lancer le menu principal

```bash
./config_menu.sh
```

### 2. Choisir un mode VPN

Par exemple : `PSK`

### 3. Attendre la configuration automatique

Toutes les étapes sont gérées (VM, certs, config, services…).

### 4. Tester la connexion depuis le client

```
vagrant ssh client01
sudo ipsec up vpn
sudo ipsec status
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
