#!/bin/bash

# setup-grub.sh
# Sets up GRUB configuration and themes

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Setting up GRUB..."

# Backup existing grub config
if [ -f /etc/default/grub ]; then
    cp /etc/default/grub /etc/default/grub.backup
    echo "Backup created at /etc/default/grub.backup"
fi

# Copy grub config
if [ -f "$DOTFILES_DIR/.config/grub/config" ]; then
    cp "$DOTFILES_DIR/.config/grub/config" /etc/default/grub
    echo "GRUB config copied"
else
    echo "Warning: No GRUB config found at .config/grub/config"
fi

# Copy grub themes
if [ -d "$DOTFILES_DIR/.config/grub/themes" ]; then
    mkdir -p /boot/grub/themes
    cp -r "$DOTFILES_DIR/.config/grub/themes"/* /boot/grub/themes/
    echo "GRUB themes copied"
fi

# Update grub
echo "Updating GRUB configuration..."
grub-mkconfig -o /boot/grub/grub.cfg

echo "GRUB setup complete!"
