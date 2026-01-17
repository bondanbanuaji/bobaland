# 🖼️ Wallpapers

The repository includes a curated collection of high-quality, Miku-themed and aesthetic anime wallpapers.

## Location
All wallpapers are stored in `assets/wallpapers/`.

## Quality
- **Resolution**: Mostly 1080p and 4K.
- **Formats**: PNG and JPG.
- **Theme**: Cyan, Teal, Grey, Anime (Miku, Bocchi, etc.).

## Usage

### Automatic Installation
Run the helper script to copy all wallpapers to `~/Pictures/Wallpapers`:
```bash
./scripts/setup-wallpapers.sh
```

### Manual Usage
Copy the files you like from `assets/wallpapers/` to your preferred wallpaper directory.

### Configuration (Hyprland)
Edit `~/.config/hypr/hyprpaper.conf`:
```conf
preload = ~/Pictures/Wallpapers/miku-teal.png
wallpaper = ,~/Pictures/Wallpapers/miku-teal.png
```
