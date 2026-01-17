# 🌊 bobaland

> *A sleek and modern Arch Linux rice featuring Hyprland, Waybar, and custom themes*

<div align="center">

![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-00ADD8?style=for-the-badge&logo=wayland&logoColor=white)
![Maintained](https://img.shields.io/badge/Maintained-Yes-green?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)

</div>

---

## 📸 Screenshots

> **Note**: Add your screenshots to the `assets/screenshots/` directory and update the paths below.

```
📂 Coming soon! Screenshots will showcase:
- Desktop environment with Hyprland
- Waybar status bar
- Rofi application launcher  
- Lock screen (Hyprlock)
- SDDM login theme
- Terminal setup
```

### Desktop && Waybar
![Desktop](assets/screenshots/desktop.png)

### Rofi Launcher
![Rofi](assets/screenshots/rofi.png)

### Lock Screen Hyprlock
![Lockscreen](assets/screenshots/lockscreen.png)

### SDDM Login Theme
![SDDM](assets/screenshots/sddm.png)

---

## ✨ Features

### 🎨 **Modern Wayland Experience**
- **Hyprland** - Dynamic tiling compositor with smooth animations
- **Waybar** - Highly customizable status bar with modules
- **Rofi** - Fast and elegant application launcher
- **Dunst** - Lightweight notification daemon

### 🖥️ **System Themes**
- **SDDM** - Custom login screen theme
- **GRUB** - Styled bootloader theme
- **Plymouth** - Beautiful boot splash screen

### 🚀 **Productivity Tools**
- **Kitty** - GPU-accelerated terminal emulator
- **Hyprlock** - Secure screen locking
- **Hypridle** - Intelligent idle management
- **Wlogout** - Elegant logout menu

### 🛠️ **Helper Scripts**
- One-command installation
- Screenshot utilities
- Wallpaper switcher
- Theme switcher
- Backup & restore tools

---

## 📋 Requirements

- **OS**: Arch Linux (or Arch-based distribution)
- **Display Server**: Wayland
- **Privileges**: Root access for system theme installation

---

## 🚀 Quick Start

For experienced users who want to get started fast:

```bash
# Clone the repository
git clone https://github.com/bondanbanuaji/bobaland.git
cd bobaland

# Review the packages list
cat packages.txt

# Run the installation script
chmod +x scripts/install/install.sh
./scripts/install/install.sh

# Log out and select Hyprland session
```

> [!WARNING]
> The installation script will create backups of existing configurations in `~/bobaland/backup/`. Review the script before running!

---

## 📖 Full Installation Guide

For detailed step-by-step instructions, including manual installation options, see:

**→ [INSTALLATION.md](INSTALLATION.md)**

---

## ⌨️ Keybindings

Quick reference for the most common shortcuts:

| Shortcut | Action |
|----------|--------|
| `SUPER + Return` | Launch terminal |
| `SUPER + D` | Open application launcher (Rofi) |
| `SUPER + Q` | Close focused window |
| `SUPER + M` | Exit Hyprland |
| `SUPER + L` | Lock screen |
| `SUPER + 1-9` | Switch to workspace 1-9 |
| `SUPER + SHIFT + 1-9` | Move window to workspace 1-9 |
| `SUPER + Mouse` | Move/resize windows |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + V` | Toggle floating |

**For the complete keybindings list, see: [KEYBINDINGS.md](KEYBINDINGS.md)**

---

## 🎨 Customization

This rice is highly customizable! You can modify:

- **Colors** - Centralized color scheme across all applications
- **Wallpapers** - Change desktop and lockscreen backgrounds
- **Animations** - Adjust Hyprland animation speeds and curves
- **Waybar** - Customize modules, layout, and styling
- **Keybindings** - Remap shortcuts to your preference
- **Window Rules** - Configure application-specific behaviors

**Complete customization guide: [CONFIGURATION.md](CONFIGURATION.md)**

---

## 🔧 Troubleshooting

Encountering issues? Common solutions:

- **Hyprland won't start**: Check logs at `~/.local/share/hyprland/hyprland.log`
- **Waybar not showing**: Verify module dependencies are installed
- **SDDM theme not applying**: Ensure theme was installed with root privileges
- **Performance issues**: Adjust animation settings in Hyprland config

**Full troubleshooting guide: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)**

---

## 📦 Package List

All required and optional packages are documented in [`packages.txt`](packages.txt).

### Core Dependencies
- `hyprland` - Window manager
- `waybar` - Status bar
- `kitty` - Terminal
- `rofi-wayland` - App launcher
- `dunst` - Notifications
- `sddm` - Display manager

*See `packages.txt` for the complete list including fonts, themes, and utilities.*

---

## 🗂️ Repository Structure

```
bobaland/
├── .config/          # User configuration files
├── themes/           # System themes (SDDM, GRUB, Plymouth)
├── wallpapers/       # Wallpaper collection
├── scripts/          # Installation and utility scripts
├── docs/             # Documentation
└── assets/           # Screenshots and media
```

---

## 🤝 Contributing

Contributions are welcome! Whether it's:
- 🐛 Bug reports
- 💡 Feature suggestions
- 📝 Documentation improvements
- 🎨 Theme variations

Feel free to open an issue or submit a pull request.

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).

---

## 🙏 Credits

**Dotfiles by**: [Bondan Banuaji](https://github.com/bondanbanuaji)

**Inspiration & Resources**:
- [Hyprland](https://hyprland.org/) - Amazing Wayland compositor
- [r/unixporn](https://reddit.com/r/unixporn) - Rice inspiration community
- Various dotfiles repositories from the community

---

## ⭐ Support

If you found this useful, consider:
- ⭐ **Starring** this repository
- 🔀 **Forking** it for your own customization
- 📢 **Sharing** it with others

---

<div align="center">

**Made with ❤️ for the Arch Linux community**

*bobaland* - where simplicity meets aesthetics

</div>
