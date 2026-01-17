# ⌨️ KEYBINDINGS.md

Complete keyboard shortcuts reference for **bobaland** Hyprland configuration

---

## 🚀 Quick Reference (Most Used)

| Shortcut | Action |
|----------|--------|
| `SUPER + Return` | Open terminal (Kitty) |
| `SUPER + D` | Application launcher (Rofi) |
| `SUPER + Q` | Close focused window |
| `SUPER + L` | Lock screen |
| `SUPER + M` | Exit Hyprland |
| `SUPER + 1-9` | Switch to workspace 1-9 |

---

## 📑 Table of Contents

1. [Window Management](#window-management)
2. [Workspace Navigation](#workspace-navigation)
3. [Applications](#applications)
4. [System Controls](#system-controls)
5. [Media Controls](#media-controls)
6. [Screenshots](#screenshots)
7. [Special Modes](#special-modes)
8. [Customizing Keybindings](#customizing-keybindings)

---

## Window Management

### Focus Windows

| Shortcut | Action |
|----------|--------|
| `SUPER + H` | Focus window to the left |
| `SUPER + L` | Focus window to the right |
| `SUPER + K` | Focus window above |
| `SUPER + J` | Focus window below |
| `SUPER + Tab` | Cycle through windows |

### Move Windows

| Shortcut | Action |
|----------|--------|
| `SUPER + SHIFT + H` | Move window left |
| `SUPER + SHIFT + L` | Move window right |
| `SUPER + SHIFT + K` | Move window up |
| `SUPER + SHIFT + J` | Move window down |

### Resize Windows

| Shortcut | Action |
|----------|--------|
| `SUPER + CTRL + H` | Resize window left |
| `SUPER + CTRL + L` | Resize window right |
| `SUPER + CTRL + K` | Resize window up |
| `SUPER + CTRL + J` | Resize window down |
| `SUPER + R` | Enter resize mode |

> **Tip**: In resize mode, use arrow keys or HJKL to resize, press `Escape` to exit

### Window States

| Shortcut | Action |
|----------|--------|
| `SUPER + F` | Toggle fullscreen |
| `SUPER + V` | Toggle floating |
| `SUPER + P` | Toggle pseudo-tiling |
| `SUPER + S` | Toggle split orientation |
| `SUPER + Q` | Close/kill window |

### Mouse Bindings

| Shortcut | Action |
|----------|--------|
| `SUPER + LEFT CLICK` | Move window |
| `SUPER + RIGHT CLICK` | Resize window |
| `SUPER + MIDDLE CLICK` | Toggle floating |

---

## Workspace Navigation

### Switch Workspaces

| Shortcut | Action |
|----------|--------|
| `SUPER + 1` | Go to workspace 1 |
| `SUPER + 2` | Go to workspace 2 |
| `SUPER + 3` | Go to workspace 3 |
| `SUPER + 4` | Go to workspace 4 |
| `SUPER + 5` | Go to workspace 5 |
| `SUPER + 6` | Go to workspace 6 |
| `SUPER + 7` | Go to workspace 7 |
| `SUPER + 8` | Go to workspace 8 |
| `SUPER + 9` | Go to workspace 9 |
| `SUPER + 0` | Go to workspace 10 |

### Alternative Workspace Navigation

| Shortcut | Action |
|----------|--------|
| `SUPER + Mouse Scroll` | Cycle through workspaces |
| `SUPER + CTRL + Left` | Previous workspace |
| `SUPER + CTRL + Right` | Next workspace |

### Move Windows to Workspaces

| Shortcut | Action |
|----------|--------|
| `SUPER + SHIFT + 1` | Move window  to workspace 1 |
| `SUPER + SHIFT + 2` | Move window to workspace 2 |
| `SUPER + SHIFT + 3` | Move window to workspace 3 |
| `SUPER + SHIFT + 4` | Move window to workspace 4 |
| `SUPER + SHIFT + 5` | Move window to workspace 5 |
| `SUPER + SHIFT + 6` | Move window to workspace 6 |
| `SUPER + SHIFT + 7` | Move window to workspace 7 |
| `SUPER + SHIFT + 8` | Move window to workspace 8 |
| `SUPER + SHIFT + 9` | Move window to workspace 9 |
| `SUPER + SHIFT + 0` | Move window to workspace 10 |

### Move & Follow to Workspace

| Shortcut | Action |
|----------|--------|
| `SUPER + ALT + 1-9` | Move window to workspace and follow |

---

## Applications

### Core Applications

| Shortcut | Action |
|----------|--------|
| `SUPER + Return` | Terminal (Kitty) |
| `SUPER + D` | Application launcher (Rofi) |
| `SUPER + E` | File manager (Thunar) |
| `SUPER + B` | Web browser (default) |

### Quick Launch

| Shortcut | Action |
|----------|--------|
| `SUPER + SHIFT + B` | Browser (Private/Incognito) |
| `SUPER + C` | VS Code / Code editor |
| `SUPER + N` | Notes app |

> **Note**: Modify these in `~/.config/hypr/keybinds.conf` to match your preferred apps

---

## System Controls

### Session Management

| Shortcut | Action |
|----------|--------|
| `SUPER + L` | Lock screen (Hyprlock) |
| `SUPER + M` | Exit Hyprland |
| `SUPER + SHIFT + M` | Logout menu (Wlogout) |
| `SUPER + SHIFT + R` | Reload Hyprland config |

### Power Management

| Shortcut | Action |
|----------|--------|
| `SUPER + SHIFT + Q` | Power menu |
| `CTRL + ALT + Delete` | Logout menu |

> **Note**: Use Wlogout menu for shutdown, reboot, suspend options

---

## Media Controls

### Volume

| Shortcut | Action |
|----------|--------|
| `XF86AudioRaiseVolume` | Volume up (+5%) |
| `XF86AudioLowerVolume` | Volume down (-5%) |
| `XF86AudioMute` | Toggle mute |
| `SUPER + =` | Volume up (alternative) |
| `SUPER + -` | Volume down (alternative) |

### Playback

| Shortcut | Action |
|----------|--------|
| `XF86AudioPlay` | Play/Pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |
| `SUPER + P` | Play/Pause (alternative) |

### Brightness

| Shortcut | Action |
|----------|--------|
| `XF86MonBrightnessUp` | Increase brightness |
| `XF86MonBrightnessDown` | Decrease brightness |
| `SUPER + F11` | Brightness down (alternative) |
| `SUPER + F12` | Brightness up (alternative) |

---

## Screenshots

| Shortcut | Action |
|----------|--------|
| `Print` | Screenshot full screen |
| `SUPER + Print` | Screenshot active window |
| `SUPER + SHIFT + S` | Screenshot area (select region) |
| `CTRL + Print` | Screenshot and edit (Swappy) |

### Screenshot Utilities
Screenshots are saved to `~/Pictures/Screenshots/` by default.

**Edit location**: `~/.config/hypr/keybinds.conf`

---

## Special Modes

### Resize Mode

```
SUPER + R → Enter resize mode
  ↑/K → Resize up
  ↓/J → Resize down
  ←/H → Resize left
  →/L → Resize right
  Escape → Exit resize mode
```

### Submap (Custom Modes)

You can create custom submaps for specific workflows. Example uses:
- Gaming mode (disable compositor effects)
- Streaming mode (specific window layouts)
- Development mode (IDE + terminal split)

**Configure**: `~/.config/hypr/keybinds.conf`

---

## Customizing Keybindings

### Configuration Location
All keybindings are defined in:
```
~/.config/hypr/keybinds.conf
```

### Syntax
```bash
# Format: bind = MODIFIERS, KEY, DISPATCHER, PARAMS
bind = SUPER, Return, exec, kitty
bind = SUPER SHIFT, Q, killactive,
```

### Common Modifiers
- `SUPER` - Windows/Super key
- `SHIFT` - Shift key
- `CTRL` - Control key
- `ALT` - Alt key

### Common Dispatchers
- `exec` - Execute a command
- `killactive` - Close focused window
- `workspace` - Switch workspace
- `movetoworkspace` - Move window to workspace
- `togglefloating` - Toggle floating mode
- `fullscreen` - Toggle fullscreen

### Example: Add Custom Keybinding
```bash
# Add to ~/.config/hypr/keybinds.conf

# Launch Firefox with SUPER + SHIFT + F
bind = SUPER SHIFT, F, exec, firefox

# Move window to scratchpad with SUPER + S
bind = SUPER, S, movetoworkspace, special:scratchpad
```

### Reload Configuration
After editing keybindings:
```bash
# Method 1: Use keybinding
SUPER + SHIFT + R

# Method 2: From terminal
hyprctl reload
```

---

## Finding Key Names

To find the name of a key for custom bindings:

```bash
# Run this command, then press the key
wev
```

Or check Hyprland documentation:
```bash
# View Hyprland keybind docs
man hyprland-keybinds
```

---

## Tips & Tricks

### 💡 Pro Tips

1. **Muscle Memory**: Practice the core shortcuts (SUPER + Return, D, Q) first
2. **Workspaces**: Use workspaces 1-9 for different contexts (1=browser, 2=dev, 3=music, etc.)
3. **Mouse + Keyboard**: Combine `SUPER + Mouse` for quick window management
4. **Resize Mode**: `SUPER + R` is faster than holding CTRL for multiple resizes
5. **Screenshots**: Set up `SUPER + SHIFT + S` muscle memory for quick area captures

### 🔄 Coming from Other WMs

**i3/Sway users**:
- Most keybindings are similar
- `$mod` is `SUPER` key
- Resize mode works the same way

**dwm/bspwm users**:
- Adjust to workspace numbers instead of tags
- Focus follows similar vim-style navigation (HJKL)

**Windows/macOS users**:
- `SUPER` = Windows key / Command key
- `SUPER + D` = Similar to Spotlight/Start menu
- `SUPER + Tab` = Alt-Tab equivalent

---

## Conflicts & Debugging

### Check if Keybinding is Taken
```bash
# List all active keybindings
hyprctl binds
```

### Test if Keys are Detected
```bash
# Install and run wev
sudo pacman -S wev
wev
```

### Common Conflicts
- **Laptop function keys**: May need `Fn` key pressed
- **Desktop environment remnants**: Remove old DE keybind daemons
- **Terminal shortcuts**: Some terminal shortcuts may conflict (e.g., `CTRL + H`)

---

## Reference Configuration

View the complete keybindings configuration:
```bash
cat ~/.config/hypr/keybinds.conf
```

Or edit directly:
```bash
nano ~/.config/hypr/keybinds.conf
```

---

**Happy navigating! ⌨️**

For more configuration options, see [CONFIGURATION.md](CONFIGURATION.md)
