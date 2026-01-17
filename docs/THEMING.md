# 🎨 Theming Guide

## Color Palette (Miku Theme)
| Color Name | Hex Code | Usage |
|------------|----------|-------|
| **Cyan/Teal** | `#39c5bb` | Accent, Borders, Active Elements |
| **Dark Grey** | `#232323` | Backgrounds |
| **Light Grey** | `#383838` | Panels, Inactive Borders |
| **White** | `#ffffff` | Text |
| **Pink** | `#ff69b4` | Secondary Accent (Sakura) |

## Changing Themes

### Wallpaper
Use the provided script:
```bash
./scripts/setup-wallpapers.sh
```
Or edit `~/.config/hypr/hyprpaper.conf`.

### GTK Theme
Install `nwg-look` to manage GTK themes.
Recommended Theme: `Arc-Dark` or `Catppuccin-Mocha`.
Recommended Icons: `Papirus-Dark`.

### Cursor
Update `~/.config/hypr/hyprland.conf`:
```bash
env = XCURSOR_THEME,Bibata-Modern-Ice
env = XCURSOR_SIZE,24
```
