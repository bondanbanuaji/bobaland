#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Copy plymouth theme
if [ -d "$DOTFILES_DIR/boot" ]; then
    THEME_NAME=$(basename "$DOTFILES_DIR"/boot/*)
    sudo cp -r "$DOTFILES_DIR/boot/$THEME_NAME" /usr/share/plymouth/themes/
    
    # Set theme
    sudo plymouth-set-default-theme -R "$THEME_NAME"
    
    # Update mkinitcpio
    if ! grep -q "plymouth" /etc/mkinitcpio.conf; then
        sudo sed -i 's/HOOKS=(base udev/HOOKS=(base udev plymouth/' /etc/mkinitcpio.conf
        sudo mkinitcpio -P
    fi
    
    echo "[✓] Plymouth theme installed: $THEME_NAME"
fi
