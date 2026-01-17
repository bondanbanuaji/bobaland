#!/bin/bash

# setup-wallpapers.sh
# Installs wallpapers to ~/Pictures/Wallpapers

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WALL_DIR="$HOME/Pictures/Wallpapers"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}[i] Setting up Wallpapers...${NC}"

# Create directory
if [ ! -d "$WALL_DIR" ]; then
    mkdir -p "$WALL_DIR"
    echo -e "${GREEN}[✓] Created $WALL_DIR${NC}"
fi

# Copy wallpapers
if [ -d "$DOTFILES_DIR/assets/wallpapers" ]; then
    echo "Copying wallpapers..."
    cp -n "$DOTFILES_DIR/assets/wallpapers"/* "$WALL_DIR/" 2>/dev/null || true
    echo -e "${GREEN}[✓] Wallpapers installed to $WALL_DIR${NC}"
else
    echo "No wallpapers found in assets/wallpapers"
fi

echo -e "${BLUE}[i] Tip: Use 'hyprpaper' or 'swww' to set your wallpaper.${NC}"
