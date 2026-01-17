#!/usr/bin/env bash

# ============================================
# bobaland - Package Installation Script
# ============================================
# Installs all required packages from packages.txt
# ============================================

set -e

# Script directory
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# Package list file
readonly PACKAGES_FILE="$REPO_ROOT/packages.txt"

# ============================================
# PARSE PACKAGES FILE
# ============================================

# Extract package names from packages.txt (removing comments and empty lines)
get_official_packages() {
    if [ ! -f "$PACKAGES_FILE" ]; then
        log_error "packages.txt not found at: $PACKAGES_FILE"
        return 1
    fi
    
    # Extract packages before AUR section, remove comments and whitespace
    sed -n '1,/# AUR PACKAGES/p' "$PACKAGES_FILE" | \
        grep -v "^#" | \
        grep -v "^$" | \
        awk '{print $1}' | \
        grep -v "^AUR"
}

# Extract AUR package names
get_aur_packages() {
    if [ ! -f "$PACKAGES_FILE" ]; then
        return 1
    fi
    
    # Extract packages after AUR section
    sed -n '/# AUR PACKAGES/,$p' "$PACKAGES_FILE" | \
        grep "^#" | \
        grep -v "^# =" | \
        grep -v "^# AUR" | \
        grep -v "^# Install" | \
        sed 's/^# //' | \
        awk '{print $1}' | \
        grep -v "^$"
}

# ============================================
# PACKAGE INSTALLATION
# ============================================

install_official_packages() {
    log_step "Reading package list from packages.txt..."
    
   local packages=$(get_official_packages)
    
    if [ -z "$packages" ]; then
        log_warning "No official packages found in packages.txt"
        return 0
    fi
    
    # Convert to array
    local package_array=($packages)
    local total=${#package_array[@]}
    
    log_info "Found $total official packages"
    
    # Update package database
    log_step "Updating package database..."
    sudo pacman -Sy
    check_status "Failed to update package database"
    
    # Filter already installed packages
    local to_install=()
    local already_installed=0
    
    for pkg in "${package_array[@]}"; do
        if is_package_installed "$pkg"; then
            ((already_installed++))
        else
            to_install+=("$pkg")
        fi
    done
    
    log_info "$already_installed packages already installed"
    
    if [ ${#to_install[@]} -eq 0 ]; then
        log_success "All official packages are already installed!"
        return 0
    fi
    
    log_info "Installing ${#to_install[@]} new packages..."
    
    # Install packages
    sudo pacman -S --needed --noconfirm "${to_install[@]}"
    check_status "Failed to install official packages"
    
    log_success "Installed ${#to_install[@]} official packages"
}

install_aur_packages() {
    # Check if AUR helper is available
    if ! has_aur_helper; then
        log_warning "No AUR helper (yay/paru) found"
        log_info "Install yay with:"
        echo ""
        echo "  cd /tmp"
        echo "  git clone https://aur.archlinux.org/yay.git"
        echo "  cd yay"
        echo "  makepkg -si"
        echo ""
        log_info "Skipping AUR packages..."
        return 0
    fi
    
    local aur_helper=$(get_aur_helper)
    log_info "Using AUR helper: $aur_helper"
    
    log_step "Reading AUR packages from packages.txt..."
    
    local aur_packages=$(get_aur_packages)
    
    if [ -z "$aur_packages" ]; then
        log_info "No AUR packages specified"
        return 0
    fi
    
    # Convert to array
    local aur_array=($aur_packages)
    local total=${#aur_array[@]}
    
    log_info "Found $total AUR packages"
    
    # Filter already installed
    local to_install_aur=()
    local already_installed_aur=0
    
    for pkg in "${aur_array[@]}"; do
        if is_package_installed "$pkg"; then
            ((already_installed_aur++))
        else
            to_install_aur+=("$pkg")
        fi
    done
    
    log_info "$already_installed_aur AUR packages already installed"
    
    if [ ${#to_install_aur[@]} -eq 0 ]; then
        log_success "All AUR packages are already installed!"
        return 0
    fi
    
    log_info "Installing ${#to_install_aur[@]} AUR packages..."
    
    # Install AUR packages
    $aur_helper -S --needed --noconfirm "${to_install_aur[@]}"
    check_status "Failed to install AUR packages"
    
    log_success "Installed ${#to_install_aur[@]} AUR packages"
}

# ============================================
# MAIN
# ============================================

main() {
    log_header "Package Installation"
    
    # Install official packages
    install_official_packages
    
    echo ""
    
    # Install AUR packages
    install_aur_packages
    
    echo ""
    log_success "Package installation completed successfully!"
}

main "$@"
