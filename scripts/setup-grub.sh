#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Backup existing grub config
sudo cp /etc/default/grub /etc/default/grub.backup

# Copy grub config
if [ -f "$DOTFILES_DIR/grub/grub" ]; then
    sudo cp "$DOTFILES_DIR/grub/grub" /etc/default/grub
fi

# Copy grub theme
if [ -d "$DOTFILES_DIR/grub/themes" ]; then
    sudo mkdir -p /boot/grub/themes
    sudo cp -r "$DOTFILES_DIR/grub/themes"/* /boot/grub/themes/
fi

# Update grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "[✓] GRUB configured"
