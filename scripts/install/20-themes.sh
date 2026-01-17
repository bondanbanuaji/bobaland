#!/usr/bin/env bash

# ============================================
# bobaland - System Theme Installer
# ============================================
# Orchestrates installation of SDDM, GRUB, and Plymouth themes
# ============================================

set -e

# Script directory
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# ============================================
# THEME INSTALLATION MENU
# ============================================

show_theme_menu() {
    log_header "System Theme Installation"
    
    echo "System themes require root privileges to install."
    echo "These are optional but recommended for a complete experience."
    echo ""
    echo "Available themes:"
    echo "  1. SDDM   - Display manager (login screen)"
    echo "  2. GRUB   - Bootloader theme"
    echo "  3. Plymouth - Boot splash screen"
    echo "  4. All of the above"
    echo "  5. Skip theme installation"
    echo ""
}

# ============================================
# THEME INSTALLER DISPATCHER
# ============================================

install_sddm_theme() {
    if [ -f "$SCRIPT_DIR/21-sddm-setup.sh" ]; then
        log_info "Running SDDM theme installer..."
        bash "$SCRIPT_DIR/21-sddm-setup.sh"
        check_status "SDDM theme installation failed"
    else
        log_warning "SDDM setup script not found"
    fi
}

install_grub_theme() {
    if [ -f "$SCRIPT_DIR/22-grub-setup.sh" ]; then
        log_info "Running GRUB theme installer..."
        bash "$SCRIPT_DIR/22-grub-setup.sh"
        check_status "GRUB theme installation failed"
    else
        log_warning "GRUB setup script not found"
    fi
}

install_plymouth_theme() {
    if [ -f "$SCRIPT_DIR/23-plymouth-setup.sh" ]; then
        log_info "Running Plymouth theme installer..."
        bash "$SCRIPT_DIR/23-plymouth-setup.sh"
        check_status "Plymouth theme installation failed"
    else
        log_warning "Plymouth setup script not found"
    fi
}

# ============================================
# INTERACTIVE MODE
# ============================================

interactive_install() {
    show_theme_menu
    
    read -p "Select option [1-5]: " choice
    
    case $choice in
        1)
            install_sddm_theme
            ;;
        2)
            install_grub_theme
            ;;
        3)
            install_plymouth_theme
            ;;
        4)
            install_sddm_theme
            echo ""
            install_grub_theme
            echo ""
            install_plymouth_theme
            ;;
        5)
            log_info "Skipping theme installation"
            return 0
            ;;
        *)
            log_warning "Invalid option, skipping theme installation"
            return 0
            ;;
    esac
}

# ============================================
# AUTOMATIC MODE
# ============================================

automatic_install() {
    log_info "Installing all system themes..."
    
    install_sddm_theme
    echo ""
    install_grub_theme
    echo ""
    install_plymouth_theme
}

# ============================================
# MAIN
# ============================================

main() {
    # Check if running interactively
    if [ -t 0 ]; then
        interactive_install
    else
        automatic_install
    fi
    
    echo ""
    log_success "Theme installation completed!"
}

main "$@"
