# 📦 INSTALLATION.md

Complete installation guide for **bobaland** - Arch Linux Hyprland rice

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Pre-Installation Checklist](#pre-installation-checklist)
3. [Installation Methods](#installation-methods)
   - [Method 1: Automated Installation](#method-1-automated-installation-recommended)
   - [Method 2: Manual Installation](#method-2-manual-installation)
4. [System Theme Installation](#system-theme-installation)
5. [Post-Installation](#post-installation)
6. [Uninstallation](#uninstallation)

---

## Prerequisites

### System Requirements
- **Operating System**: Arch Linux or Arch-based distribution (EndeavourOS, Manjaro, etc.)
- **Display Server**: Wayland support
- **Privileges**: Root/sudo access for system-level installations
- **Storage**: ~100 MB for configurations and themes
- **Internet**: For downloading packages

### Required Tools
```bash
# Install base requirements
sudo pacman -S git base-devel
```

---

## Pre-Installation Checklist

> [!WARNING]
> **IMPORTANT**: This installation will modify your system configuration!

Before proceeding:

- [ ] **Backup your existing configurations**
  ```bash
  # Backup current configs (if they exist)
  mkdir -p ~/dotfiles-backup-$(date +%Y%m%d)
  cp -r ~/.config ~/dotfiles-backup-$(date +%Y%m%d)/
  ```

- [ ] **Review the packages list**
  ```bash
  cat packages.txt
  ```

- [ ] **Ensure you have a working internet connection**
  ```bash
  ping -c 3 archlinux.org
  ```

- [ ] **Have a way to access TTY** (Ctrl+Alt+F2) in case of issues

---

## Installation Methods

### Method 1: Automated Installation (Recommended)

The automated script handles everything including backups, symlinks, and theme installation.

#### Step 1: Clone the Repository
```bash
# Clone to your home directory
cd ~
git clone https://github.com/bondanbanuaji/bobaland.git
cd bobaland
```

#### Step 2: Review Installation Script
```bash
# Optional: Review what the script does
cat scripts/install/install.sh
```

#### Step 3: Run the Installer
```bash
# Make the script executable
chmod +x scripts/install/install.sh

# Run the installation
./scripts/install/install.sh
```

The script will:
1. ✅ Create backup of existing configurations
2. ✅ Install required packages (with confirmation)
3. ✅ Create symbolic links
4. ✅ Install system themes (SDDM, GRUB, Plymouth)
5. ✅ Enable required services
6. ✅ Provide next steps

#### Step 4: Follow On-Screen Instructions

The script will guide you through each step and ask for confirmation before making changes.

---

### Method 2: Manual Installation

For advanced users who want more control over the installation process.

#### Step 1: Clone the Repository
```bash
cd ~
git clone https://github.com/bondanbanuaji/bobaland.git
cd bobaland
```

#### Step 2: Install Packages

##### Core Packages
```bash
sudo pacman -S hyprland waybar rofi-wayland dunst kitty \
               sddm hyprlock hypridle wlogout \
               pipewire pipewire-pulse wireplumber \
               xdg-desktop-portal-hyprland polkit-kde-agent
```

##### Utilities
```bash
sudo pacman -S grim slurp swappy wl-clipboard \
               brightnessctl playerctl pamixer \
               network-manager-applet bluez bluez-utils \
               thunar thunar-volman gvfs
```

##### Fonts
```bash
sudo pacman -S ttf-font-awesome ttf-jetbrains-mono-nerd \
               noto-fonts noto-fonts-emoji
```

##### Themes & Icons
```bash
sudo pacman -S papirus-icon-theme \
               gtk-engine-murrine gnome-themes-extra
```

##### AUR Packages (using yay or paru)
```bash
yay -S swww waybar-module-pacman-updates-git wlogout
```

> See [`packages.txt`](packages.txt) for the complete list

#### Step 3: Create Backups
```bash
# Backup existing configs
mkdir -p ~/bobaland/backup
cp -r ~/.config/hypr ~/bobaland/backup/ 2>/dev/null || true
cp -r ~/.config/waybar ~/bobaland/backup/ 2>/dev/null || true
cp -r ~/.config/kitty ~/bobaland/backup/ 2>/dev/null || true
# Add more as needed
```

#### Step 4: Create Symbolic Links

##### Using GNU Stow (Recommended)
```bash
# Install stow if not already installed
sudo pacman -S stow

# Navigate to repo
cd ~/bobaland

# Create symlinks for .config
stow -t ~/.config .config

# Verify symlinks were created
ls -la ~/.config/hypr
```

##### Manual Symlinking
```bash
# Create symlinks manually
ln -sf ~/bobaland/.config/hypr ~/.config/hypr
ln -sf ~/bobaland/.config/waybar ~/.config/waybar
ln -sf ~/bobaland/.config/kitty ~/.config/kitty
ln -sf ~/bobaland/.config/rofi ~/.config/rofi
ln -sf ~/bobaland/.config/dunst ~/.config/dunst
ln -sf ~/bobaland/.config/wlogout ~/.config/wlogout
ln -sf ~/bobaland/.config/nvim ~/.config/nvim

# Verify symlinks
ls -la ~/.config/ | grep bobaland
```

#### Step 5: Install System Themes

See [System Theme Installation](#system-theme-installation) section below.

---

## System Theme Installation

System themes require root privileges and manual installation.

### SDDM Theme

```bash
# Copy SDDM theme to system directory
sudo cp -r ~/bobaland/themes/sddm /usr/share/sddm/themes/bobaland

# Configure SDDM to use the theme
sudo nano /etc/sddm.conf.d/theme.conf
```

Add:
```ini
[Theme]
Current=bobaland
```

```bash
# Enable SDDM service
sudo systemctl enable sddm
```

### GRUB Theme

```bash
# Copy GRUB theme
sudo cp -r ~/bobaland/themes/grub /usr/share/grub/themes/bobaland

# Edit GRUB configuration
sudo nano /etc/default/grub
```

Add/modify:
```bash
GRUB_THEME="/usr/share/grub/themes/bobaland/theme.txt"
```

```bash
# Regenerate GRUB configuration
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Plymouth Theme

```bash
# Copy Plymouth theme
sudo cp -r ~/bobaland/themes/plymouth /usr/share/plymouth/themes/bobaland

# Install and set the theme
sudo plymouth-set-default-theme -R bobaland
```

---

## Post-Installation

### Step 1: Enable Services

```bash
# Enable Bluetooth (if needed)
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Enable NetworkManager (if not already enabled)
sudo systemctl enable NetworkManager
```

### Step 2: Set Wallpaper

The wallpaper will be set automatically via Hyprland's startup script. To change it:

```bash
# Edit the startup script
nano ~/.config/hypr/startup.conf

# Or use the wallpaper switcher
~/bobaland/scripts/utils/wallpaper-switcher.sh
```

### Step 3: Log Out and Select Hyprland

1. Log out of your current session
2. At the login screen (SDDM), select **Hyprland** from the session menu
3. Log in

### Step 4: First Login Checks

After logging into Hyprland:

```bash
# Check if Waybar is running
pgrep waybar

# Check if dunst is running
pgrep dunst

# Test a notification
notify-send "Test" "bobaland installation successful!"
```

### Recommended First Steps

1. **Test keybindings**: Press `SUPER + Return` to open terminal
2. **Open launcher**: Press `SUPER + D` for Rofi
3. **Check display**: Verify monitors are configured correctly
4. **Test lock screen**: Press `SUPER + L`
5. **Review logs**: Check `~/.local/share/hyprland/hyprland.log` for any errors

---

## Uninstallation

To remove bobaland and restore your previous setup:

### Remove Symlinks

```bash
# Remove symlinks
rm ~/.config/hypr
rm ~/.config/waybar
rm ~/.config/kitty
rm ~/.config/rofi
rm ~/.config/dunst
rm ~/.config/wlogout
rm ~/.config/nvim
```

### Restore Backups

```bash
# Restore from backup
cp -r ~/bobaland/backup/* ~/.config/
```

### Remove System Themes (Optional)

```bash
# Remove SDDM theme
sudo rm -rf /usr/share/sddm/themes/bobaland

# Reset SDDM configuration
sudo nano /etc/sddm.conf.d/theme.conf  # Remove bobaland reference

# Remove GRUB theme
sudo rm -rf /usr/share/grub/themes/bobaland
sudo nano /etc/default/grub  # Remove GRUB_THEME line
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Remove Plymouth theme
sudo rm -rf /usr/share/plymouth/themes/bobaland
sudo plymouth-set-default-theme -R <previous-theme>
```

### Remove Repository (Optional)

```bash
rm -rf ~/bobaland
```

---

## Troubleshooting Installation

### Common Issues

**Issue**: Symlinks already exist
```bash
# Solution: Remove existing symlinks/directories first
rm -rf ~/.config/hypr  # Be careful with this!
# Then retry symlinking
```

**Issue**: Permission denied errors
```bash
# Solution: Use sudo for system-level operations
sudo cp -r themes/sddm /usr/share/sddm/themes/
```

**Issue**: Missing packages
```bash
# Solution: Install missing packages manually
sudo pacman -S <package-name>
```

**Issue**: AUR helper not installed
```bash
# Install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

For more troubleshooting, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## Next Steps

After successful installation:

- 📖 Read [CONFIGURATION.md](CONFIGURATION.md) to customize your setup
- ⌨️ Learn shortcuts in [KEYBINDINGS.md](KEYBINDINGS.md)
- 🎨 Modify colors, wallpapers, and themes to your preference
- 📸 Share your setup on [r/unixporn](https://reddit.com/r/unixporn)!

---

**Enjoy your new bobaland setup! 🌊**
