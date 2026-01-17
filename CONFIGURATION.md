# 🎨 CONFIGURATION.md

Customization guide for **bobaland** - Make it your own!

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Color Scheme](#color-scheme)
3. [Wallpapers](#wallpapers)
4. [Hyprland Configuration](#hyprland-configuration)
5. [Waybar Customization](#waybar-customization)
6. [Terminal (Kitty)](#terminal-kitty)
7. [Rofi](#rofi)
8. [System Themes](#system-themes)
9. [Scripts & Utilities](#scripts--utilities)

---

##Overview

The bobaland configuration is designed to be modular and easy to customize. This guide covers all major customization options.

### Configuration Philosophy

- **Modular**: Configs are split into logical files
- **Commented**: Important sections have explanatory comments
- **Centralized**: Colors and common settings in dedicated files
- **Portable**: Easy to sync across multiple machines

### File Locations

```
~/.config/hypr/        # Hyprland configuration
~/.config/waybar/      # Waybar status bar
~/.config/kitty/       # Terminal settings
~/.config/rofi/        # Application launcher
~/.config/dunst/       # Notifications
```

---

## Color Scheme

### Global Color Configuration

For consistent theming, colors are defined across multiple config files. To change your color scheme:

#### Hyprland Colors
Edit `~/.config/hypr/themes.conf` (or colors section in `hyprland.conf`):

```bash
# Example color definitions
$background = rgb(1a1a1a)
$foreground = rgb(e0e0e0)
$primary = rgb(7aa2f7)
$secondary = rgb(9ece6a)
$accent = rgb(bb9af7)
$urgent = rgb(f7768e)
```

#### Waybar Colors
Edit `~/.config/waybar/style.css`:

```css
/* Color variables */
@define-color background #1a1a1a;
@define-color foreground #e0e0e0;
@define-color primary #7aa2f7;
@define-color secondary #9ece6a;
@define-color accent #bb9af7;
```

#### Kitty Terminal Colors
Edit `~/.config/kitty/theme.conf`:

```ini
# Foreground and background
foreground #e0e0e0
background #1a1a1a

# Cursor
cursor #c0c0c0

# Color palette
color0 #1a1a1a
color1 #f7768e
color2 #9ece6a
color3 #e0af68
color4 #7aa2f7
color5 #bb9af7
color6 #7dcfff
color7 #c0caf5
```

### Popular Color Schemes

#### Tokyo Night
```bash
$background = rgb(1a1b26)
$foreground = rgb(c0caf5)
$primary = rgb(7aa2f7)
$secondary = rgb(9ece6a)
$accent = rgb(bb9af7)
```

#### Catppuccin Mocha
```bash
$background = rgb(1e1e2e)
$foreground = rgb(cdd6f4)
$primary = rgb(89b4fa)
$secondary = rgb(a6e3a1)
$accent = rgb(f5c2e7)
```

#### Dracula
```bash
$background = rgb(282a36)
$foreground = rgb(f8f8f2)
$primary = rgb(bd93f9)
$secondary = rgb(50fa7b)
$accent = rgb(ff79c6)
```

#### Nord
```bash
$background = rgb(2e3440)
$foreground = rgb(eceff4)
$primary = rgb(88c0d0)
$secondary = rgb(a3be8c)
$accent = rgb(b48ead)
```

> **Tip**: After changing colors, reload Hyprland with `SUPER + SHIFT + R`

---

## Wallpapers

### Setting Wallpapers

Wallpapers are managed by `swww` (or `hyprpaper`).

#### Primary Wallpaper
Edit `~/.config/hypr/startup.conf`:

```bash
# Change the wallpaper path
exec-once = swww img ~/bobaland/wallpapers/main.jpg
```

#### Using the Wallpaper Switcher
```bash
# Run the wallpaper switcher script
~/bobaland/scripts/utils/wallpaper-switcher.sh

# Or create a keybinding in hyprland.conf:
bind = SUPER, W, exec, ~/bobaland/scripts/utils/wallpaper-switcher.sh
```

### Lock Screen Wallpaper

Edit `~/.config/hypr/hyprlock.conf`:

```bash
background {
    monitor =
    path = ~/bobaland/wallpapers/lockscreen.jpg
    blur_passes = 3
    contrast = 0.8
    brightness = 0.6
}
```

### Adding New Wallpapers

```bash
# Copy wallpapers to the collection
cp /path/to/wallpaper.jpg ~/bobaland/wallpapers/collection/

# Update the wallpaper
swww img ~/bobaland/wallpapers/collection/wallpaper.jpg
```

---

## Hyprland Configuration

### Configuration Files

Hyprland config is split into modules:

```
~/.config/hypr/
├── hyprland.conf       # Main config (sources other files)
├── monitors.conf       # Monitor setup
├── keybinds.conf       # Keyboard shortcuts
├── rules.conf          # Window rules
├── startup.conf        # Autostart applications
└── themes.conf         # Colors and theming
```

### Monitor Configuration

Edit `~/.config/hypr/monitors.conf`:

```bash
# Example: Single 1080p monitor
monitor = , 1920x1080@60, 0x0, 1

# Example: Dual monitor setup
monitor = DP-1, 2560x1440@144, 0x0, 1
monitor = HDMI-A-1, 1920x1080@60, 2560x0, 1

# Example: Laptop + external monitor
monitor = eDP-1, 1920x1080@60, 0x0, 1
monitor = HDMI-A-1, 2560x1440@144, 1920x0, 1.25
```

**Find your monitor names**:
```bash
hyprctl monitors
```

### Animations

Edit `~/.config/hypr/hyprland.conf`:

```bash
animations {
    enabled = yes
    
    # Animation curves
    bezier = smooth, 0.05, 0.9, 0.1, 1.0
    
    # Window animations
    animation = windows, 1, 5, smooth, slide
    animation = windowsOut, 1, 5, smooth, popin 80%
    
    # Fade animations
    animation = fadeIn, 1, 5, smooth
    animation = fadeOut, 1, 5, smooth
    
    # Workspace animations
    animation = workspaces, 1, 6, smooth, slide
}
```

**Disable animations for performance**:
```bash
animations {
    enabled = no
}
```

### Window Rules

Edit `~/.config/hypr/rules.conf`:

```bash
# Float specific applications
windowrule = float, ^(pavucontrol)$
windowrule = float, ^(nm-connection-editor)$

# Workspace assignments
windowrule = workspace 2, ^(firefox)$
windowrule = workspace 3, ^(code)$

# Opacity rules
windowrule = opacity 0.9 0.9, ^(kitty)$
windowrule = opacity 0.85 0.85, ^(thunar)$

# Size rules
windowrule = size 800 600, ^(pavucontrol)$
```

### Startup Applications

Edit `~/.config/hypr/startup.conf`:

```bash
# Core components
exec-once = waybar
exec-once = dunst
exec-once = swww init

# System tray apps
exec-once = nm-applet
exec-once = blueman-applet

# Authentication agent
exec-once = /usr/lib/polkit-kde-authentication-agent-1

# Wallpaper
exec-once = swww img ~/bobaland/wallpapers/main.jpg

# Auto-start apps
exec-once = [workspace 1 silent] firefox
exec-once = [workspace 2 silent] kitty
```

---

## Waybar Customization

### Configuration Files

```
~/.config/waybar/
├── config.jsonc        # Main configuration
├── style.css           # Styling
└── modules/            # Individual module configs (optional)
```

### Layout & Modules

Edit `~/.config/waybar/config.jsonc`:

```jsonc
{
    "layer": "top",
    "position": "top",
    "height": 30,
    
    // Left modules
    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    
    // Center modules
    "modules-center": ["clock"],
    
    // Right modules
    "modules-right": [
        "pulseaudio",
        "network",
        "cpu",
        "memory",
        "battery",
        "tray"
    ]
}
```

### Module Configuration Examples

#### Clock Format
```jsonc
"clock": {
    "format": "{:%H:%M}",
    "format-alt": "{:%A, %B %d, %Y (%R)}",
    "tooltip-format": "<tt><small>{calendar}</small></tt>",
    "calendar": {
        "mode": "year",
        "mode-mon-col": 3,
        "weeks-pos": "right",
        "on-scroll": 1
    }
}
```

#### Battery
```jsonc
"battery": {
    "states": {
        "warning": 30,
        "critical": 15
    },
    "format": "{icon} {capacity}%",
    "format-charging": " {capacity}%",
    "format-icons": ["", "", "", "", ""]
}
```

### Styling

Edit `~/.config/waybar/style.css`:

```css
/* Bar styling */
* {
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 14px;
}

window#waybar {
    background-color: rgba(26, 26, 26, 0.9);
    color: #e0e0e0;
    border-bottom: 2px solid #7aa2f7;
}

/* Workspace styling */
#workspaces button {
    padding: 0 10px;
    background-color: transparent;
    color: #c0c0c0;
}

#workspaces button.active {
    background-color: #7aa2f7;
    color: #1a1a1a;
}
```

---

## Terminal (Kitty)

### Configuration Files

```
~/.config/kitty/
├── kitty.conf          # Main configuration
├── theme.conf          # Color theme
└── keybinds.conf       # Custom keybindings
```

### Font Configuration

Edit `~/.config/kitty/kitty.conf`:

```ini
# Font family
font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto

# Font size
font_size 12.0

# Font features
disable_ligatures never
```

### Window Settings

```ini
# Window padding
window_padding_width 10

# Background opacity
background_opacity 0.95

# Blur (requires compositor support)
background_blur 1
```

### Tab Bar

```ini
# Tab bar style
tab_bar_style powerline
tab_powerline_style slanted

# Tab bar colors
active_tab_foreground   #1a1a1a
active_tab_background   #7aa2f7
inactive_tab_foreground #c0c0c0
inactive_tab_background #404040
```

---

## Rofi

### Configuration

Edit `~/.config/rofi/config.rasi`:

```css
configuration {
    modi: "drun,window,run";
    show-icons: true;
    display-drun: "Apps";
    display-window: "Windows";
    drun-display-format: "{name}";
}

@theme "theme.rasi"
```

### Custom Theme

Create `~/.config/rofi/theme.rasi`:

```css
* {
    bg: #1a1a1a;
    fg: #e0e0e0;
    primary: #7aa2f7;
    
    background-color: @bg;
    text-color: @fg;
}

window {
    width: 600px;
    border: 2px;
    border-color: @primary;
    border-radius: 10px;
    padding: 20px;
}

inputbar {
    spacing: 10px;
    padding: 10px;
    border-radius: 5px;
    background-color: #262626;
}

listview {
    lines: 8;
    spacing: 5px;
}

element selected {
    background-color: @primary;
    text-color: @bg;
    border-radius: 5px;
}
```

---

## System Themes

### SDDM Theme

Edit `/usr/share/sddm/themes/bobaland/theme.conf`:

```ini
[General]
Background="background.jpg"
Font="JetBrainsMono Nerd Font"
FontSize=12
```

### GRUB Theme

Edit `/usr/share/grub/themes/bobaland/theme.txt`:

```txt
title-text: "bobaland"
title-color: "#7aa2f7"
desktop-image: "background.png"
terminal-font: "Terminus Regular 14"
```

---

## Scripts & Utilities

### Wallpaper Switcher

Edit `~/bobaland/scripts/utils/wallpaper-switcher.sh` to customize directory:

```bash
WALLPAPER_DIR="$HOME/bobaland/wallpapers/collection"
```

### Screenshot Script

Edit `~/bobaland/scripts/utils/screenshot.sh`:

```bash
# Change screenshot directory
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

# Change screenshot filename format
FILENAME="screenshot_$(date +%Y%m%d_%H%M%S).png"
```

---

## Reload Configuration

After making changes:

```bash
# Reload Hyprland config
hyprctl reload
# Or use keybinding: SUPER + SHIFT + R

# Restart Waybar
killall waybar && waybar &

# Reload kitty config (in kitty terminal)
Ctrl + Shift + F5
```

---

## Tips & Best Practices

1. **Backup before editing**: Always backup configs before major changes
2. **Test incrementally**: Make small changes and test
3. **Comment your changes**: Add comments explaining custom modifications
4. **Use variables**: Define colors/sizes as variables for easy theme switching
5. **Version control**: Commit changes to git for easy rollbacks

---

**Happy customizing! 🎨**

For more help, see [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
