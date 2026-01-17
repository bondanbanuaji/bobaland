# 🔧 TROUBLESHOOTING.md

Common issues and solutions for **bobaland**

---

## 📋 Table of Contents

1. [Installation Issues](#installation-issues)
2. [Hyprland Issues](#hyprland-issues)
3. [Waybar Issues](#waybar-issues)
4. [SDDM Theme Issues](#sddm-theme-issues)
5. [Audio Issues](#audio-issues)
6. [Network/Bluetooth](#networkbluetooth)
7. [General Troubleshooting](#general-troubleshooting)
8. [FAQ](#faq)

---

## Installation Issues

### Symlinks Already Exist

**Problem**: Error message "file exists" when creating symlinks

**Solution**:
```bash
# Check if the path is a symlink or directory
ls -la ~/.config/hypr

# If it's a directory, backup and remove
mv ~/.config/hypr ~/.config/hypr.backup

# If it's a symlink, remove it
rm ~/.config/hypr

# Then recreate the symlink
ln -sf ~/bobaland/.config/hypr ~/.config/hypr
```

### Permission Denied Errors

**Problem**: "Permission denied" during theme installation

**Solution**:
```bash
# Use sudo for system-level operations
sudo cp -r ~/bobaland/themes/sddm /usr/share/sddm/themes/bobaland

# Check file ownership
ls -la /usr/share/sddm/themes/

# Fix permissions if needed
sudo chmod -R 755 /usr/share/sddm/themes/bobaland
```

### Missing Packages

**Problem**: Installation script fails due to missing packages

**Solution**:
```bash
# Update package database
sudo pacman -Sy

# Install missing package manually
sudo pacman -S <package-name>

# For AUR packages, use AUR helper
yay -S <package-name>

# If package doesn't exist, find alternatives
pacman -Ss <search-term>
```

### AUR Helper Not Installed

**Problem**: Script requires `yay` or `paru` but not installed

**Solution**:
```bash
# Install yay
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Or install paru
cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

---

## Hyprland Issues

### Hyprland Won't Start

**Problem**: Black screen or immediate crash to TTY after login

**Diagnosis**:
```bash
# Check Hyprland logs
cat ~/.local/share/hyprland/hyprland.log

# Try starting Hyprland manually from TTY
Hyprland
```

**Common Solutions**:

1. **Missing drivers** (most common):
   ```bash
   # For NVIDIA
   sudo pacman -S nvidia-dkms nvidia-utils

   # For AMD
   sudo pacman -S mesa vulkan-radeon

   # For Intel
   sudo pacman -S mesa vulkan-intel
   ```

2. **Config syntax error**:
   ```bash
   # Test config syntax
   hyprctl reload

   # Check for errors in config
   cat ~/.config/hypr/hyprland.conf | grep -v "^#" | grep -v "^$"
   ```

3. **Portal issues**:
   ```bash
   # Install/reinstall portal
   sudo pacman -S xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
   ```

### Monitor Detection Issues

**Problem**: External monitor not detected or wrong resolution

**Solution**:
```bash
# List available monitors
hyprctl monitors

# Get detailed monitor info
wayland-info | grep output

# Edit monitor config
nano ~/.config/hypr/monitors.conf

# Use auto-detection
monitor = , preferred, auto, 1

# Or specify manually
monitor = HDMI-A-1, 1920x1080@60, 0x0, 1
```

### Performance Issues / Lag

**Problem**: Stuttering, low FPS, or general sluggishness

**Solutions**:

1. **Disable animations**:
   ```bash
   # Edit hyprland.conf
   nano ~/.config/hypr/hyprland.conf

   # Set animations to off
   animations {
       enabled = no
   }
   ```

2. **Reduce blur**:
   ```bash
   decoration {
       blur {
           enabled = no
       }
   }
   ```

3. **Check GPU usage**:
   ```bash
   # Install monitoring tool
   sudo pacman -S nvtop  # For NVIDIA
   sudo pacman -S radeontop  # For AMD

   # Monitor GPU  
   nvtop
   ```

4. **Disable VSync** (if tearing isn't an issue):
   ```bash
   misc {
       vrr = 0
   }
   ```

### Windows Not Following Rules

**Problem**: Window rules not applying

**Solution**:
```bash
# Get window class/title
hyprctl clients

# Look for the window you want to configure
# Note the "class" and "title" fields

# Update rules.conf with correct class
windowrule = float, ^(exact-class-name)$

# Reload config
hyprctl reload
```

---

## Waybar Issues

### Waybar Not Showing

**Problem**: Waybar doesn't appear after login

**Diagnosis**:
```bash
# Check if Waybar is running
pgrep waybar

# Try starting manually
waybar

# Check for errors
waybar 2>&1 | grep error
```

**Solutions**:

1. **Config syntax error**:
   ```bash
   # Validate JSON
   jsonlint ~/.config/waybar/config.jsonc

   # Or use jq
   jq . ~/.config/waybar/config.jsonc
   ```

2. **Missing dependencies**:
   ```bash
   # Install all Waybar dependencies
   sudo pacman -S waybar otf-font-awesome \
                  ttf-font-awesome ttf-jetbrains-mono-nerd
   ```

3. **Restart Waybar**:
   ```bash
   killall waybar
   waybar &
   ```

### Modules Not Working

**Problem**: Specific modules show errors or don't display

**Common Module Issues**:

1. **Battery module** (laptops):
   ```bash
   # Check battery path
   ls /sys/class/power_supply/

   # Update config with correct battery name
   "battery": {
       "bat": "BAT0",  # or BAT1, etc.
   }
   ```

2. **Network module**:
   ```bash
   # Install NetworkManager
   sudo pacman -S networkmanager
   sudo systemctl enable NetworkManager
   sudo systemctl start NetworkManager
   ```

3. **Audio module**:
   ```bash
   # Install PipeWire/PulseAudio
   sudo pacman -S pipewire pipewire-pulse wireplumber
   ```

### Styling Issues

**Problem**: Waybar looks broken or colors are wrong

**Solution**:
```bash
# Check CSS syntax
cat ~/.config/waybar/style.css

# Test with minimal config
mv ~/.config/waybar/style.css ~/.config/waybar/style.css.backup
waybar

# If it works, CSS syntax error in original file
```

---

## SDDM Theme Issues

### Theme Not Applying

**Problem**: SDDM still shows default theme

**Solution**:
```bash
# Check SDDM config
cat /etc/sddm.conf.d/theme.conf

# Should contain:
# [Theme]
# Current=bobaland

# Check theme exists
ls /usr/share/sddm/themes/bobaland

# Reconfigure SDDM
sudo systemctl restart sddm
```

### SDDM Shows Errors

**Problem**: Error messages on login screen

**Diagnosis**:
```bash
# Check SDDM logs
journalctl -u sddm -b

# Check theme files
ls -la /usr/share/sddm/themes/bobaland/
```

**Solution**:
```bash
# Reinstall theme
sudo rm -rf /usr/share/sddm/themes/bobaland
sudo cp -r ~/bobaland/themes/sddm /usr/share/sddm/themes/bobaland
sudo systemctl restart sddm
```

---

## Audio Issues

### No Sound

**Problem**: Audio not working

**Solution**:
```bash
# Check if sound card is detected
aplay -l

# Install PipeWire (if not installed)
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber

# Start PipeWire
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# Test audio
speaker-test -c2

# Adjust volume
pamixer --set-volume 50
```

### Bluetooth Audio Issues

**Problem**: Bluetooth headphones not working

**Solution**:
```bash
# Install Bluetooth packages
sudo pacman -S bluez bluez-utils

# Enable Bluetooth
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Connect via bluetoothctl
bluetoothctl
# > scan on
# > pair XX:XX:XX:XX:XX:XX
# > connect XX:XX:XX:XX:XX:XX
# > trust XX:XX:XX:XX:XX:XX
```

---

## Network/Bluetooth

### WiFi Not Working

**Problem**: Can't connect to WiFi

**Solution**:
```bash
# Install NetworkManager
sudo pacman -S networkmanager nm-connection-editor network-manager-applet

# Enable and start
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

# GUI network manager
nm-connection-editor

# Or use nmtui (TUI)
nmtui
```

### Bluetooth Not Working

**Problem**: Can't find/connect Bluetooth devices

**Solution**:
```bash
# Check Bluetooth status
systemctl status bluetooth

# Check if blocked
rfkill list

# Unblock if needed
rfkill unblock bluetooth

# Restart Bluetooth
sudo systemctl restart bluetooth
```

---

## General Troubleshooting

### Check Logs

```bash
# Hyprland logs
cat ~/.local/share/hyprland/hyprland.log

# System logs
journalctl -b

# Specific service logs
journalctl -u sddm -b
journalctl -u NetworkManager

# Watch logs in real-time
journalctl -f
```

### Hyprland Crash/Freeze

**Problem**: Hyprland freezes or crashes

**Emergency Solutions**:

1. **Switch to TTY**: `Ctrl + Alt + F2`
2. **Kill Hyprland**: `pkill Hyprland`
3. **Check logs**: `cat ~/.local/share/hyprland/hyprland.log`
4. **Restart**: `sudo systemctl restart sddm`

### Reset to Default Config

**Problem**: Config is completely broken

**Solution**:
```bash
# Remove symlinks
rm ~/.config/hypr
rm ~/.config/waybar
rm ~/.config/kitty

# Restore from backup
cp -r ~/bobaland/backup/* ~/.config/

# Or pull fresh config
cd ~/bobaland
git stash
git pull
./scripts/install/10-symlinks.sh
```

### Clear Cache

**Problem**: Weird behavior after updates

**Solution**:
```bash
# Clear Hyprland cache
rm -rf ~/.cache/hyprland/

# Clear general cache
rm -rf ~/.cache/*

# Restart Hyprland
```

---

## FAQ

### Q: How do I take a screenshot?
**A**: Press `Print` for full screen, `SUPER + Print` for active window, or `SUPER + SHIFT + S` for area selection. Screenshots are saved to `~/Pictures/Screenshots/`.

### Q: How do I change the wallpaper?
**A**: Edit `~/.config/hypr/startup.conf` or use `~/bobaland/scripts/utils/wallpaper-switcher.sh`.

### Q: How do I add custom keybindings?
**A**: Edit `~/.config/hypr/keybinds.conf` and reload with `SUPER + SHIFT + R`.

### Q: Waybar disappeared after restart
**A**: Check if it's in autostart: `cat ~/.config/hypr/startup.conf | grep waybar`. If not, add: `exec-once = waybar`.

### Q: How do I update the dotfiles?
**A**: `cd ~/bobaland && git pull`. Then reload configs.

### Q: Can I use this with NVIDIA?
**A**: Yes, but install `nvidia-dkms` and add these to hyprland.conf:
```bash
env = LIBVA_DRIVER_NAME,nvidia
env = XDG_SESSION_TYPE,wayland
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1
```

### Q: How do I uninstall everything?
**A**: See the [Uninstallation section in INSTALLATION.md](INSTALLATION.md#uninstallation).

### Q: Where can I get help?
**A**:
- Check logs first
- Search GitHub issues
- Ask in Hyprland Discord
- Post on r/hyprland subreddit

---

## Still Having Issues?

If none of these solutions work:

1. **Check Hyprland documentation**: [hyprland.org](https://hyprland.org)
2. **Search existing issues**: [github.com/hyprwm/Hyprland/issues](https://github.com/hyprwm/Hyprland/issues)
3. **Ask for help**:
   - Hyprland Discord
   - r/hyprland subreddit
   - Open an issue in this repository

When asking for help, always provide:
- `hyprctl version` output
- Relevant logs
- Hardware specs (GPU, CPU)
- What you've already tried

---

**Good luck! 🔧**
