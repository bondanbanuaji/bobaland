# Theming Guide

## Changing Wallpapers
Wallpapers are stored in `assets/wallpapers`. You can change the wallpaper by editing `hyprland.conf` (if using hyprpaper) or running:
```bash
hyprctl hyprpaper wallpaper "monitor,/path/to/wallpaper"
```

## Customizing Colors
Color schemes are defined in `scripts/utils/colors.sh` for scripts.
For applications:
- **Kitty**: Edit `config/kitty/kitty.conf`
- **Waybar**: Edit `config/waybar/style.css`

## Boot Themes
Run the installation script again and choose the theming option to re-apply GRUB or Plymouth themes.
