# Bobaland - My Arch-Hyprland

![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-00A4A6?style=for-the-badge&logo=hyprland&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)

## 🌙 Tentang Filosofi Ini
Setup Arch Linux bertema Hatsune Miku. Terlahir dari "kegabutan" produktif seorang mahasiswa di keheningan malam, dikemas apik oleh Hyprland, dan dirapikan oleh kesenjangan. Modular, otomatis, cepat, dan estetis — bukti nyata bahwa waktu luang pun bisa bertransformasi menjadi karya yang berarti, dengan harapan tulus untuk menjadi yang paling bermanfaat bagi sesama. ~

## Table of Contents
- [Preview](#preview)
- [Features](#features)
- [Notes & Important Info](#notes--important-info)
- [Keybindings](#keybindings)
- [Installation](#installation)
- [What Gets Installed](#what-gets-installed)
- [Dotfiles Repo](#dotfiles-repo)
- [Troubleshooting](#troubleshooting)
- [Post-Installation](#post-installation)
- [Updating](#updating)
- [Uninstallation](#uninstallation)
- [Credits](#credits)

## Preview
> [!NOTE]
> Screenshots and videos will be added soon!

*(Placeholder for screenshots)*
*(Placeholder for video demo)*

## Features
- ✨ **Interactive Installation**: User-friendly menu to guide you through the process.
- 🔒 **Safe & Reversible**: Automatically backs up your existing configurations before applying changes.
- 📦 **Complete Setup**: Installs necessary packages including Hyprland, Waybar, Rofi, and more.
- 🎨 **Beautiful Interface**: Features a custom anime ASCII art banner and colored output.
- 📊 **Progress Monitoring**: Clear progress bars and logging for transparency.
- 🚀 **Automated Deployment**: Clones and deploys dotfiles using GNU Stow.

## Notes & Important Info
- This script is designed for **Arch Linux**.
- Ensure you have a working internet connection before running the installer.
- The installer creates a log file in `~/.cache/bobaland/` for debugging.

## Keybindings
Press <kbd>SUPER</kbd> + <kbd>H</kbd> after installation to view the full list of keybindings.

## Installation

```bash
git clone --depth=1 https://github.com/bondanbanuaji/bobaland.git
cd bobaland
chmod +x install.sh
./install.sh
```

## What Gets Installed
- **Window Manager**: Hyprland
- **Bar**: Waybar
- **Notification**: SwayNC
- **Launcher**: Rofi (Wayland)
- **Terminal**: Ghostty (or fallback), Zsh, Tmux
- **Audio**: Pipewire, Wireplumber, Cava
- **Fonts**: JetBrains Mono Nerd Font, Font Awesome, Noto Emoji
- **Tools**: Neovim, Stow, Git, Curl, Wget

## Dotfiles Repo
👉 **[bondanbanuaji/Dotfiles](https://github.com/bondanbanuaji/Dotfiles)**

The installer automatically clones and deploys these dotfiles using GNU Stow.

## Troubleshooting
If you encounter issues:
1.  Check the log file: `~/.cache/bobaland/install_TIMESTAMP.log`
2.  Ensure your system is up to date: `sudo pacman -Syu`
3.  If dotfiles conflict, the backup is located in `~/.config-backup-TIMESTAMP/`

## Post-Installation
1.  Logout and login again.
2.  Select **Hyprland** from your display manager (SDDM/GDM/etc).
3.  Enjoy your new setup!

## Updating
To update your dotfiles:
1.  Navigate to `~/dotfiles`
2.  Run `git pull`
3.  Run `stow -v .`

## Uninstallation
To revert changes, simply restore your backed-up configs from `~/.config-backup-*/`.

## Credits
- r/unixporn
- JaKooLit/Hyprland-Dots
- Hyde-project/hyde
- mylinuxforwork/dotfiles
- ViegPhunt/Arch-Hyprland
