# 📘 Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Components](#components)
5. [Keybindings](#keybindings)
6. [Customization](#customization)

## Introduction
Bobaland is a curated collection of dotfiles for Arch Linux, centered around the **Hyprland** compositor. The design philosophy focuses on:
- **Aesthetics**: A consistent Miku-themed (Cyan/Teal/Grey) color palette.
- **Performance**: Lightweight components.
- **Usability**: Intuitive keybindings and workflows.

## Prerequisites
- **OS**: Arch Linux (minimal install recommended)
- **Graphics**: GPU drivers installed (Nvidia/AMD/Intel)
- **Font**: Nerd Fonts (JetBrainsMono Nerd Font recommended)

## Installation

### Automated Install
The `install.sh` script handles everything:
```bash
git clone https://github.com/bondanbanuaji/bobaland.git
cd bobaland
./install.sh
```
Follow the on-screen prompts.
- **Backup**: The script will offer to backup your existing `.config`.
- **Packages**: Installs required packages from `packages.txt`.

### Manual Install
1. Copy folders from `.config/` to `~/.config/`.
2. Install packages listed in `scripts/packages.txt`.
3. Copy assets from `assets/` to appropriate locations.

## Components

| Component | Description | Config Location |
|-----------|-------------|-----------------|
| **Hyprland** | Window Manager | `~/.config/hypr/` |
| **Waybar** | Status Bar | `~/.config/waybar/` |
| **Dunst** | Notifications | `~/.config/dunst/` |
| **Kitty** | Terminal Emulator | `~/.config/kitty/` |
| **Wofi** | App Launcher | `~/.config/wofi/` |
| **Swaylock** | Lock Screen | `~/.config/swaylock/` |
| **GRUB** | Bootloader Theme | `/boot/grub/themes/` |

## Keybindings
See [KEYBINDINGS.md](KEYBINDINGS.md) for a full reference.

Common bindings:
- `SUPER + Q`: Launch Terminal
- `SUPER + C`: Close window
- `SUPER + E`: File Manager
- `SUPER + SPACE`: Launcher
- `SUPER + L`: Lock Screen

## Customization

### Wallpapers
Wallpapers are stored in `~/Pictures/Wallpapers`.
To change the active wallpaper, edit `~/.config/hypr/hyprpaper.conf` or use the provided wallpaper script.

### Themes
The color scheme is centralized where possible.
- **GTK Theme**: Set via `nwg-look` or `lxappearance`.
- **Cursor**: Hyprcursor or standard XCursor.

## Troubleshooting
If you encounter issues, check `~/.cache/hypr/hyprland.log`.
Report issues on the [GitHub Issues](https://github.com/bondanbanuaji/bobaland/issues) page.
