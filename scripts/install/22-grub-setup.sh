#!/usr/bin/env bash

# ============================================
# bobaland - GRUB Theme Setup
# ============================================
# Installs GRUB bootloader theme
# ============================================

set -e

# Script directory
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Theme paths
readonly THEME_SOURCE="$REPO_ROOT/themes/grub"
readonly THEME_TARGET="/usr/share/grub/themes/bobaland"
readonly GRUB_CONFIG="/etc/default/grub"
readonly GRUB_BACKUP="/etc/default/grub.backup.$(date +%Y%m%d-%H%M%S)"

# ============================================
# GRUB INSTALLATION
# ============================================

install_grub_theme() {
    log_header "GRUB  Theme Installation"
    
    # Check if GRUB is installed
    if ! command_exists grub-mkconfig; then
        log_error "GRUB is not installed"
        log_info "This system may use a different bootloader"
        return 1
    fi
    
    log_success "GRUB is installed"
    
    # Check if theme directory exists in repo
    if [ ! -d "$THEME_SOURCE" ]; then
        log_warning "GRUB theme not found in repository: $THEME_SOURCE"
        log_info "Skipping GRUB theme installation"
        return 0
    fi
    
    # Backup existing GRUB config
    log_step "Backing up GRUB configuration..."
    sudo cp "$GRUB_CONFIG" "$GRUB_BACKUP"
    log_success "Backup created: $GRUB_BACKUP"
    
    # Copy theme to system directory
    log_step "Installing GRUB theme to $THEME_TARGET..."
    
    sudo mkdir -p "$(dirname "$THEME_TARGET")"
    sudo cp -r "$THEME_SOURCE" "$THEME_TARGET"
    check_status "Failed to copy GRUB theme"
    
    log_success "GRUB theme files copied"
    
    # Set proper permissions
    log_step "Setting permissions..."
    sudo chmod -R 755 "$THEME_TARGET"
    sudo chown -R root:root "$THEME_TARGET"
    
    # Update GRUB configuration
    log_step "Updating GRUB configuration..."
    
    # Remove existing GRUB_THEME line if present
    sudo sed -i '/^GRUB_THEME=/d' "$GRUB_CONFIG"
    
    # Add new GRUB_THEME line
    echo 'GRUB_THEME="/usr/share/grub/themes/bobaland/theme.txt"' | sudo tee -a "$GRUB_CONFIG" > /dev/null
    
    log_success "GRUB configuration updated"
    
    # Regenerate GRUB configuration
    log_step "Regenerating GRUB configuration..."
    
    if [ -d /boot/efi ]; then
        # UEFI system
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    else
        # BIOS system
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
    
    check_status "Failed to regenerate GRUB configuration"
    
    log_success "GRUB configuration regenerated"
    
    echo ""
    log_success "GRUB theme installation complete!"
    log_info "The theme will be active on next boot"
    log_info "To restore original config: sudo cp $GRUB_BACKUP $GRUB_CONFIG && sudo grub-mkconfig -o /boot/grub/grub.cfg"
}

# ============================================
# MAIN
# ============================================

main() {
    install_grub_theme
}

main "$@"
