#!/usr/bin/env bash

# ============================================
# bobaland - SDDM Theme Setup
# ============================================
# Installs SDDM login screen theme
# ============================================

set -e

# Script directory
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Theme paths
readonly THEME_SOURCE="$REPO_ROOT/themes/sddm"
readonly THEME_TARGET="/usr/share/sddm/themes/bobaland"
readonly SDDM_CONFIG="/etc/sddm.conf.d/theme.conf"

# ============================================
# SDDM INSTALLATION
# ============================================

install_sddm_theme() {
    log_header "SDDM Theme Installation"
    
    # Check if SDDM is installed
    if ! command_exists sddm; then
        log_error "SDDM is not installed"
        log_info "Install with: sudo pacman -S sddm"
        return 1
    fi
    
    log_success "SDDM is installed"
    
    # Check if theme directory exists in repo
    if [ ! -d "$THEME_SOURCE" ]; then
        log_warning "SDDM theme not found in repository: $THEME_SOURCE"
        log_info "Skipping SDDM theme installation"
        return 0
    fi
    
    # Copy theme to system directory
    log_step "Installing SDDM theme to $THEME_TARGET..."
    
    sudo mkdir -p "$(dirname "$THEME_TARGET")"
    sudo cp -r "$THEME_SOURCE" "$THEME_TARGET"
    check_status "Failed to copy SDDM theme"
    
    log_success "SDDM theme files copied"
    
    # Set proper permissions
    log_step "Setting permissions..."
    sudo chmod -R 755 "$THEME_TARGET"
    sudo chown -R root:root "$THEME_TARGET"
    
    # Configure SDDM to use the theme
    log_step "Configuring SDDM..."
    
    sudo mkdir -p "/etc/sddm.conf.d"
    
    cat | sudo tee "$SDDM_CONFIG" > /dev/null << EOF
[Theme]
Current=bobaland

[Users]
HideUsers=
HideShells=
RememberLastUser=true
EOF

    log_success "SDDM configured to use bobaland theme"
    
    # Enable SDDM service
    if systemctl is-enabled sddm &> /dev/null; then
        log_info "SDDM service already enabled"
    else
        log_step "Enabling SDDM service..."
        sudo systemctl enable sddm
        log_success "SDDM service enabled"
    fi
    
    echo ""
    log_success "SDDM theme installation complete!"
    log_info "The theme will be active after reboot or: sudo systemctl restart sddm"
}

# ============================================
# MAIN
# ============================================

main() {
    install_sddm_theme
}

main "$@"
