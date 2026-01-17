#!/usr/bin/env bash

# ============================================
# bobaland - Main Installation Script
# ============================================
# Interactive installer for bobaland dotfiles
# Repository: github.com/bondanbanuaji/bobaland
# Author: Bondan Banuaji
# ============================================

set -e # Exit on error

# ============================================
# SCRIPT CONFIGURATION
# ============================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Installation modes
INTERACTIVE=true
INSTALL_PACKAGES=true
CREATE_SYMLINKS=true
INSTALL_THEMES=true
ENABLE_SERVICES=true

# ============================================
# HELP MESSAGE
# ============================================

show_help() {
    cat << EOF
bobaland Installation Script

Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -s, --silent            Silent mode (no prompts, use defaults)
    -p, --skip-packages     Skip package installation
    -l, --skip-symlinks     Skip symlink creation
    -t, --skip-themes       Skip system theme installation
    -v, --skip-services     Skip service enablement
    --packages-only         Only install packages
    --symlinks-only         Only create symlinks
    --themes-only           Only install themes

EXAMPLES:
    # Interactive installation (default)
    ./install.sh

    # Silent installation
    ./install.sh --silent

    # Install packages only
    ./install.sh --packages-only

    # Skip themes (useful for testing)
    ./install.sh --skip-themes

For more information, see: https://github.com/bondanbanuaji/bobaland

EOF
}

# ============================================
# ARGUMENT PARSING
# ============================================

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -s|--silent)
                INTERACTIVE=false
                shift
                ;;
            -p|--skip-packages)
                INSTALL_PACKAGES=false
                shift
                ;;
            -l|--skip-symlinks)
                CREATE_SYMLINKS=false
                shift
                ;;
            -t|--skip-themes)
                INSTALL_THEMES=false
                shift
                ;;
            -v|--skip-services)
                ENABLE_SERVICES=false
                shift
                ;;
            --packages-only)
                INSTALL_PACKAGES=true
                CREATE_SYMLINKS=false
                INSTALL_THEMES=false
                ENABLE_SERVICES=false
                shift
                ;;
            --symlinks-only)
                INSTALL_PACKAGES=false
                CREATE_SYMLINKS=true
                INSTALL_THEMES=false
                ENABLE_SERVICES=false
                shift
                ;;
            --themes-only)
                INSTALL_PACKAGES=false
                CREATE_SYMLINKS=false
                INSTALL_THEMES=true
                ENABLE_SERVICES=false
                shift
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
}

# ============================================
# WELCOME MESSAGE
# ============================================

show_welcome() {
    clear
    cat << "EOF"
    ╔═════════════════════════════════════════╗
    ║                                         ║
    ║           🌊 bobaland 🌊                ║
    ║                                         ║
    ║   Arch Linux Dotfiles Installation     ║
    ║         Hyprland  •  Waybar             ║
    ║                                         ║
    ╚═════════════════════════════════════════╝

EOF

    echo "Welcome to the bobaland installation script!"
    echo "This will install and configure your Hyprland rice."
    echo ""
    
    log_info "Repository: $REPO_ROOT"
    log_info "Log file: $LOG_FILE"
    echo ""
}

# ============================================
# PRE-INSTALLATION CHECKS
# ============================================

pre_install_checks() {
    log_header "Pre-Installation Checks"
    
    # Check if running Arch Linux
    if [ ! -f /etc/arch-release ]; then
        log_warning "This script is designed for Arch Linux."
        if [ "$INTERACTIVE" = true ]; then
            confirm_or_exit "Continue anyway?"
        fi
    else
        log_success "Running on Arch Linux"
    fi
    
    # Check internet connection
    log_step "Checking internet connection..."
    if ping -c 1 archlinux.org &> /dev/null; then
        log_success "Internet connection OK"
    else
        die "No internet connection. Please check your network."
    fi
    
    # Check if git is installed
    if ! command_exists git; then
        log_warning "Git is not installed"
        log_step "Installing git..."
        sudo pacman -S --noconfirm git
        check_status "Failed to install git"
    else
        log_success "Git is installed"
    fi
    
    # Check current directory
    if [ ! -f "$REPO_ROOT/README.md" ]; then
        log_warning "Could not find README.md. Are you in the bobaland directory?"
        if [ "$INTERACTIVE" = true ]; then
            confirm_or_exit "Continue anyway?"
        fi
    else
        log_success "Repository structure looks good"
    fi
    
    # Detect GPU
    local gpu=$(get_gpu_vendor)
    log_info "Detected GPU: $gpu"
    
    if [ "$gpu" = "nvidia" ]; then
        log_warning "NVIDIA GPU detected. You may need additional configuration."
        log_info "See: https://wiki.hyprland.org/Nvidia/"
        if [ "$INTERACTIVE" = true ]; then
            press_any_key
        fi
    fi
    
    echo ""
}

# ============================================
# INSTALLATION SUMMARY
# ============================================

show_summary() {
    log_header "Installation Summary"
    
    echo "The following steps will be performed:"
    echo ""
    
    if [ "$INSTALL_PACKAGES" = true ]; then
        echo "  ✓ Install required packages"
    else
        echo "  ✗ Skip package installation"
    fi
    
    if [ "$CREATE_SYMLINKS" = true ]; then
        echo "  ✓ Create configuration symlinks"
    else
        echo "  ✗ Skip symlink creation"
    fi
    
    if [ "$INSTALL_THEMES" = true ]; then
        echo "  ✓ Install system themes (SDDM, GRUB, Plymouth)"
    else
        echo "  ✗ Skip theme installation"
    fi
    
    if [ "$ENABLE_SERVICES" = true ]; then
        echo "  ✓ Enable systemd services"
    else
        echo "  ✗ Skip service enablement"
    fi
    
    echo ""
    
    if [ "$INTERACTIVE" = true ]; then
        confirm_or_exit "Proceed with installation?"
    fi
}

# ============================================
# RUN INSTALLATION SCRIPTS
# ============================================

run_packages_script() {
    if [ "$INSTALL_PACKAGES" != true ]; then
        return 0
    fi
    
    log_header "Installing Packages"
    
    if [ -f "$SCRIPT_DIR/00-packages.sh" ]; then
        bash "$SCRIPT_DIR/00-packages.sh"
        check_status "Package installation failed"
    else
        log_warning "Package installation script not found, skipping..."
    fi
}

run_symlinks_script() {
    if [ "$CREATE_SYMLINKS" != true ]; then
        return 0
    fi
    
    log_header "Creating Symlinks"
    
    if [ -f "$SCRIPT_DIR/10-symlinks.sh" ]; then
        bash "$SCRIPT_DIR/10-symlinks.sh"
        check_status "Symlink creation failed"
    else
        log_warning "Symlink script not found, skipping..."
    fi
}

run_themes_script() {
    if [ "$INSTALL_THEMES" != true ]; then
        return 0
    fi
    
    log_header "Installing System Themes"
    
    if [ -f "$SCRIPT_DIR/20-themes.sh" ]; then
        bash "$SCRIPT_DIR/20-themes.sh"
        check_status "Theme installation failed"
    else
        log_warning "Theme installation script not found, skipping..."
    fi
}

run_services_script() {
    if [ "$ENABLE_SERVICES" != true ]; then
        return 0
    fi
    
    log_header "Enabling Services"
    
    if [ -f "$SCRIPT_DIR/30-services.sh" ]; then
        bash "$SCRIPT_DIR/30-services.sh"
        check_status "Service enablement failed"
    else
        log_warning "Service script not found, skipping..."
    fi
}

# ============================================
# POST-INSTALLATION
# ============================================

post_install() {
    log_header "Installation Complete!"
    
    echo ""
    echo "🎉 bobaland has been installed successfully!"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  1. Log out of your current session"
    echo "  2. Select 'Hyprland' from your display manager"
    echo "  3. Log in and enjoy your new setup!"
    echo ""
    echo "Useful commands:"
    echo "  • SUPER + Return     - Open terminal"
    echo "  • SUPER + D          - Application launcher"
    echo "  • SUPER + L          - Lock screen"
    echo "  • SUPER + SHIFT + R  - Reload Hyprland config"
    echo ""
    echo "Documentation:"
    echo "  • Keybindings: $REPO_ROOT/KEYBINDINGS.md"
    echo "  • Configuration: $REPO_ROOT/CONFIGURATION.md"
    echo "  • Troubleshooting: $REPO_ROOT/TROUBLESHOOTING.md"
    echo ""
    echo "Installation log saved to: $LOG_FILE"
    echo ""
    
    log_success "Installation completed without errors!"
}

# ============================================
# ERROR HANDLER
# ============================================

handle_error() {
    local exit_code=$?
    
    echo ""
    log_error "Installation failed with exit code: $exit_code"
    echo ""
    echo "Please check the log file for details:"
    echo "  $LOG_FILE"
    echo ""
    echo "For help, see:"
    echo "  • $REPO_ROOT/TROUBLESHOOTING.md"
    echo "  • https://github.com/bondanbanuaji/bobaland/issues"
    echo ""
    
    exit $exit_code
}

# ============================================
# MAIN FUNCTION
# ============================================

main() {
    # Set error trap
    trap handle_error ERR
    
    # Parse command line arguments
    parse_arguments "$@"
    
    # Initialize utilities
    init_utils
    
    # Show welcome message (unless silent mode)
    if [ "$INTERACTIVE" = true ]; then
        show_welcome
    fi
    
    # Run pre-installation checks
    pre_install_checks
    
    # Show installation summary
    if [ "$INTERACTIVE" = true ]; then
        show_summary
    fi
    
    # Run installation scripts in order
    run_packages_script
    run_symlinks_script
    run_themes_script
    run_services_script
    
    # Post-installation message
    post_install
}

# ============================================
# SCRIPT ENTRY POINT
# ============================================

# Run main function with all arguments
main "$@"
