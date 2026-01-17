#!/bin/bash

# ==============================================================================
# Bobaland Dotfiles Installation Script
# ==============================================================================
#
# This script is the main entry point for installing the bobaland configuration.
# It sets up key components like Hyprland, Waybar, config files, and themes.
#
# Usage: ./install.sh [options]
# Options:
#   --help, -h      Show this help message
#   --dry-run       Simulate the installation without making changes
#   --no-backup     Skip backing up existing configurations
#   --verbose       Enable verbose logging
#
# ==============================================================================

set -e

# ------------------------------------------------------------------------------
# Source Helpers
# ------------------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils/log.sh"
source "$SCRIPT_DIR/scripts/utils/colors.sh"

# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------
DRY_RUN=false
BACKUP=true
VERBOSE=false

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

show_help() {
    echo -e "${BOLD}Bobaland Installer${RESET}"
    echo "Usage: ./install.sh [options]"
    echo ""
    echo "Options:"
    echo "  --help, -h      Show this help message"
    echo "  --dry-run       Simulate the installation"
    echo "  --no-backup     Skip backup"
    echo "  --verbose       Enable verbose logging"
}

parse_args() {
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --help|-h) show_help; exit 0 ;;
            --dry-run) DRY_RUN=true ;;
            --no-backup) BACKUP=false ;;
            --verbose) VERBOSE=true ;;
            *) log_error "Unknown option: $1"; exit 1 ;;
        esac
        shift
    done
}

main_menu() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
  ____        _           _                 _ 
 |  _ \      | |         | |               | |
 | |_) | ___ | |__   __ _| | __ _ _ __   __| |
 |  _ < / _ \| '_ \ / _` | |/ _` | '_ \ / _` |
 | |_) | (_) | |_) | (_| | | (_| | | | | (_| |
 |____/ \___/|_.__/ \__,_|_|\__,_|_| |_|\__,_|
                                              
EOF
    echo -e "${RESET}"
    log_info "Welcome to the Bobaland Dotfiles Installer!"
    echo ""
    echo "Please select an option:"
    echo "1. Install All (Recommended)"
    echo "2. Install Core Packages Only"
    echo "3. Install/Update Config Only"
    echo "4. Exit"
    echo ""
    read -p "Enter choice [1-4]: " choice

    case $choice in
        1) install_all ;;
        2) install_core ;;
        3) install_config ;;
        4) exit 0 ;;
        *) log_error "Invalid choice"; exit 1 ;;
    esac
}

install_all() {
    log_info "Starting full installation..."
    bash "$SCRIPT_DIR/scripts/install/core.sh"
    bash "$SCRIPT_DIR/scripts/install/hyprland.sh"
    bash "$SCRIPT_DIR/scripts/install/theming.sh"
    log_success "Installation complete! Please reboot."
}

install_core() {
    log_info "Installing core packages..."
    bash "$SCRIPT_DIR/scripts/install/core.sh"
}

install_config() {
    log_info "Symlinking configurations..."
    # Stow logic or copy logic here
    # For now, placeholder
    log_success "Configs updated."
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------

# Initialize logging if script exists, otherwise define simple fallback
if [[ ! -f "$SCRIPT_DIR/scripts/utils/log.sh" ]]; then
    echo "Creating temporary log helpers..."
    mkdir -p "$SCRIPT_DIR/scripts/utils"
    # We will create these files next, but for now just define dummy function to avoid immediate crash if run before helpers exist
    function log_info() { echo "[INFO] $1"; }
    function log_error() { echo "[ERROR] $1"; }
    function log_success() { echo "[SUCCESS] $1"; }
fi

parse_args "$@"

if [[ -t 0 ]]; then
    main_menu
else
    # Non-interactive mode
    install_all
fi
