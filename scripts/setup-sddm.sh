#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Copy SDDM theme
if [ -d "$DOTFILES_DIR/sddm" ]; then
    THEME_NAME=$(basename "$DOTFILES_DIR"/sddm/*)
    sudo cp -r "$DOTFILES_DIR/sddm/$THEME_NAME" /usr/share/sddm/themes/
    
    # Update sddm.conf
    sudo mkdir -p /etc/sddm.conf.d
    sudo bash -c "cat > /etc/sddm.conf.d/theme.conf << EOF
[Theme]
Current=$THEME_NAME
EOF"
    
    echo "[✓] SDDM theme installed: $THEME_NAME"
fi
