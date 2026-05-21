<div align="center">

```
   █████╗ ███╗   ██╗███╗   ██╗ █████╗ ██╗  ██╗
  ██╔══██╗████╗  ██║████╗  ██║██╔══██╗╚██╗██╔╝
  ███████║██╔██╗ ██║██╔██╗ ██║███████║ ╚███╔╝
  ██╔══██║██║╚██╗██║██║╚██╗██║██╔══██║ ██╔██╗
  ██║  ██║██║ ╚████║██║ ╚████║██║  ██║██╔╝ ██╗
  ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝
```

**AnnaX Linux** — Une distro Arch Linux préconfigurée, belle et prête à l'emploi.

> ⚠️ **VERSION BÊTA TEST** — Cette distro est en cours de développement actif. Des bugs peuvent apparaître, des fonctionnalités peuvent changer. N'utilise pas en production.

![Arch](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![KDE](https://img.shields.io/badge/KDE_Plasma-1D99F3?style=for-the-badge&logo=kde&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=wayland&logoColor=black)
![Catppuccin](https://img.shields.io/badge/Catppuccin_Mocha-CBA6F7?style=for-the-badge&logoColor=black)

</div>

---

## 🌟 C'est quoi AnnaX Linux ?

AnnaX Linux est une distribution basée sur **Arch Linux**, conçue pour être **installée en quelques minutes** avec un environnement de bureau déjà configuré et esthétique dès la première connexion.

Elle embarque :
- Un thème **Catppuccin Mocha** cohérent sur toute l'interface
- Un CLI maison `annax` pour tout gérer facilement
- Un écran de bienvenue interactif au premier démarrage
- Le support **AMD + NVIDIA hybride** prêt à l'emploi
- Un installeur guidé depuis le live ISO

---

## 🖥️ Environnements de bureau disponibles

| Environnement | Description |
|---|---|
| **KDE Plasma** | Bureau complet, moderne, hautement personnalisable |
| **Hyprland** | Compositeur Wayland avec animations et tiling dynamique |

Les deux sont préconfigurés avec le thème Catppuccin Mocha au moment de l'installation.

---

## ✨ Fonctionnalités

- 🚀 **Installation rapide** — ISO bootable, installeur guidé `annax setup`
- 🎨 **Thème unifié** — Catppuccin Mocha partout (KDE, terminal, apps)
- 📦 **CLI `annax`** — Gestion de paquets, GPU, énergie, miroirs, services
- 🔄 **Auto-update** — `annax self-update` pour mettre à jour les scripts depuis GitHub
- 🎮 **Support gaming** — Drivers NVIDIA open-source en un seul commande
- 🌐 **AUR intégré** — `annax aur` installe paru automatiquement
- ⚡ **Performance** — `auto-cpufreq`, `tlp`, gestion des gouverneurs CPU
- 🖱️ **GPU hybride** — Bascule AMD/NVIDIA/Hybrid avec `annax gpu`
- 🧹 **Nettoyage facilité** — Orphelins, cache pacman, miroirs rapides
- 💬 **Bienvenue interactif** — Écran de bienvenue avec infos système et guide

---

## 📦 CLI `annax` — Toutes les commandes

### Paquets

```bash
annax update                   # Mettre à jour le système (pacman + AUR)
annax install <paquet>         # Installer un paquet (pacman ou AUR auto-détecté)
annax remove  <paquet>         # Désinstaller un paquet + ses orphelins
annax search  <terme>          # Rechercher un paquet
annax info    <paquet>         # Détails d'un paquet (version, dépendances...)
annax list                     # Lister les paquets installés explicitement
annax orphans                  # Voir et supprimer les paquets orphelins
annax clean                    # Nettoyer le cache pacman
```

### Système

```bash
annax sysinfo                  # Infos complètes du système
annax services                 # Statut des services AnnaX
annax mirrors                  # Mettre à jour les miroirs (FR, BE, DE)
annax gpu [status|amd|nvidia|hybrid]          # Gérer le GPU hybride
annax power [status|auto|performance|powersave] # Profil énergie CPU
```

### Configuration

```bash
annax dotfiles [hyprland|kitty|waybar]  # Réinstaller une config de bureau
annax theme [mocha|latte|frappe|macchiato]      # Changer le thème Catppuccin
```

### Installation & Outils

```bash
annax setup                    # Lancer l'installeur (live ISO uniquement)
annax setup gaming             # Installer les drivers NVIDIA
annax aur                      # Installer paru (helper AUR)
```

### Mise à jour AnnaX

```bash
annax self-update              # Télécharger la dernière version des scripts
                               # depuis GitHub (annax, annax-install, annax-welcome)
```

---

## 🎮 Support GPU NVIDIA

AnnaX supporte les configurations **AMD + NVIDIA hybride** (ordinateurs portables gaming).

```bash
annax setup gaming     # Installe nvidia-open-dkms, nvidia-utils, egl-wayland...

annax gpu status       # Voir le GPU actif
annax gpu hybrid       # Mode hybride (AMD par défaut, NVIDIA à la demande)
annax gpu nvidia       # NVIDIA forcé tout le temps
annax gpu amd          # AMD uniquement (NVIDIA désactivé)
```

En mode hybride, utilise `DRI_PRIME=1 <commande>` pour lancer une app sur le GPU NVIDIA.

---

## 🔧 Builder l'ISO

### Prérequis

```bash
sudo pacman -S archiso squashfs-tools
```

### Commandes

```bash
sudo ./build.sh          # Build l'ISO (défaut)
sudo ./build.sh clean    # Nettoyer les fichiers temporaires
sudo ./build.sh test     # Tester l'ISO dans QEMU (UEFI + SPICE + disque virtuel 50G)
sudo ./build.sh all      # Nettoyer + build en une seule commande
```

### Tester dans QEMU

Le script `build.sh test` lance automatiquement QEMU avec :
- **UEFI** via OVMF (systemd-boot)
- **SPICE** pour le copier-coller entre hôte et VM
- **Disque virtuel** de 50 Go pour tester l'installation complète
- **Réseau** via ethernet virtuel (détecté automatiquement par NetworkManager)

Sur l'hôte :
```bash
sudo pacman -S qemu-full edk2-ovmf virt-viewer
```

---

## 💿 Installer AnnaX Linux

1. **Télécharge l'ISO** depuis les releases GitHub
2. **Crée une clé USB bootable** :
   ```bash
   sudo dd if=annaxiso-*.iso of=/dev/sdX bs=4M status=progress && sync
   ```
3. **Démarre sur la clé USB** (mode UEFI requis)
4. **Lance l'installeur** :
   ```bash
   annax setup
   ```
5. **Suis les étapes** : langue, disque, utilisateur, bureau (KDE ou Hyprland)
6. **Redémarre** et profite !

---

## 🔄 Mises à jour post-installation

Pour récupérer les dernières améliorations des scripts AnnaX sans réinstaller :

```bash
annax self-update
```

Cette commande télécharge depuis GitHub :
- `/usr/local/bin/annax` — CLI principal
- `/usr/local/bin/annax-install` — Installeur
- `/usr/local/bin/annax-welcome` — Écran de bienvenue

---

## 🗂️ Structure du projet

```
annaxiso/
├── airootfs/                  # Système de fichiers du live ISO
│   └── usr/local/bin/
│       ├── annax              # CLI principal
│       ├── annax-install      # Installeur guidé
│       └── annax-welcome      # Écran de bienvenue KDE
├── packages.x86_64            # Liste des paquets inclus dans l'ISO
├── profiledef.sh              # Profil archiso (nom, label, boot...)
├── build.sh                   # Script de build et test QEMU
└── pacman.conf                # Config pacman de l'ISO
```

---

## ⚠️ Statut bêta

AnnaX Linux est actuellement en **bêta test**. Ce que ça veut dire :

- ✅ Le build de l'ISO fonctionne
- ✅ L'installeur KDE Plasma + Hyprland fonctionne
- ✅ Le CLI `annax` est fonctionnel
- ⚠️ Des bugs peuvent apparaître lors de l'installation
- ⚠️ Certaines fonctionnalités sont encore en développement (`annax theme`)
- ⚠️ La liste des paquets peut changer entre les versions

Si tu rencontres un bug, ouvre une **issue** sur ce dépôt.

---

## 🤝 Contribuer

Les contributions sont les bienvenues ! Pour contribuer :

1. Fork le repo
2. Crée une branche : `git checkout -b ma-feature`
3. Commit tes changements
4. Ouvre une Pull Request

---

<div align="center">

Fait avec ❤️ — **AnnaX Linux** © 2025

*Arch Linux • KDE Plasma • Hyprland • Catppuccin Mocha*

</div>
