#!/usr/bin/env bash

# ============================================
# bobaland - Plymouth Theme Setup
# ============================================
# Installs Plymouth boot splash theme
# ============================================

set -e

# Script directory
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Theme paths
readonly THEME_SOURCE="$REPO_ROOT/themes/plymouth"
readonly THEME_TARGET="/usr/share/plymouth/themes/bobaland"

# ============================================
# PLYMOUTH INSTALLATION
# ============================================

install_plymouth_theme() {
    log_header "Plymouth Theme Installation"
    
    # Check if Plymouth is installed
    if ! command_exists plymouth-set-default-theme; then
        log_warning "Plymouth is not installed"
        log_info "Install with: sudo pacman -S plymouth"
        
        if ask_yes_no "Install Plymouth now?"; then
            sudo pacman -S --noconfirm plymouth
            check_status "Failed to install Plymouth"
        else
            log_info "Skipping Plymouth theme installation"
            return 0
        fi
    fi
    
    log_success "Plymouth is installed"
    
    # Check if theme directory exists in repo
    if [ ! -d "$THEME_SOURCE" ]; then
        log_warning "Plymouth theme not found in repository: $THEME_SOURCE"
        log_info "Skipping Plymouth theme installation"
        return 0
    fi
    
    # Copy theme to system directory
    log_step "Installing Plymouth theme to $THEME_TARGET..."
    
    sudo mkdir -p "$(dirname "$THEME_TARGET")"
    sudo cp -r "$THEME_SOURCE" "$THEME_TARGET"
    check_status "Failed to copy Plymouth theme"
    
    log_success "Plymouth theme files copied"
    
    # Set proper permissions
    log_step "Setting permissions..."
    sudo chmod -R 755 "$THEME_TARGET"
    sudo chown -R root:root "$THEME_TARGET"
    
    # Set Plymouth theme and rebuild initramfs
    log_step "Setting Plymouth theme..."
    sudo plymouth-set-default-theme -R bobaland
    check_status "Failed to set Plymouth theme"
    
    log_success "Plymouth theme set and initramfs rebuilt"
    
    # Update GRUB to show Plymouth
    log_step "Updating GRUB for Plymouth..."
    
    local grub_config="/etc/default/grub"
    if [ -f "$grub_config" ]; then
        # Backup GRUB config
        sudo cp "$grub_config" "${grub_config}.backup.plymouth"
        
        # Check if quiet splash is already present
        if ! grep -q "quiet splash" "$grub_config"; then
            sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash /' "$grub_config"
            
            # Regenerate GRUB config
            sudo grub-mkconfig -o /boot/grub/grub.cfg
            
            log_success "GRUB updated for Plymouth"
        else
            log_info "GRUB already configured for Plymouth"
        fi
    else
        log_warning "GRUB config not found, skip GRUB update"
    fi
    
    echo ""
    log_success "Plymouth theme installation complete!"
    log_info "The theme will be active on next boot"
    log_info "Note: Plymouth requires proper initramfs hooks to work correctly"
}

# ============================================
# MAIN
# ============================================

main() {
    install_plymouth_theme
}

main "$@"
