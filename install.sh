#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "Jangan run pake sudo! Script ini bakal minta password kalo perlu"
   exit 1
fi

# Banner
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════╗
║     Dotfiles Installation Script      ║
║          Arch Linux Setup             ║
╚═══════════════════════════════════════╝
EOF
echo -e "${NC}"

# Detect dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
print_info "Dotfiles directory: $DOTFILES_DIR"

# Backup existing configs
backup_configs() {
    print_info "Backup config yang ada..."
    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    if [ -d "$HOME/.config" ]; then
        cp -r "$HOME/.config" "$BACKUP_DIR/" 2>/dev/null || true
        print_success "Backup di: $BACKUP_DIR"
    fi
}

# Install packages
install_packages() {
    print_info "Installing packages..."
    
    # Update system
    sudo pacman -Syu --noconfirm
    
    # Install packages dari packages.txt
    while IFS= read -r package || [ -n "$package" ]; do
        # Skip comments and empty lines
        [[ "$package" =~ ^#.*$ ]] && continue
        [[ -z "$package" ]] && continue
        
        if pacman -Qi "$package" &> /dev/null; then
            print_warning "$package udah ke-install"
        else
            print_info "Installing $package..."
            sudo pacman -S --noconfirm "$package" || print_error "Gagal install $package"
        fi
    done < "$DOTFILES_DIR/packages.txt"
    
    print_success "Package installation selesai"
}

# Install AUR helper (yay)
install_yay() {
    if command -v yay &> /dev/null; then
        print_warning "yay udah ke-install"
        return
    fi
    
    print_info "Installing yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
    print_success "yay ter-install"
}

# Link dotfiles
link_dotfiles() {
    print_info "Linking dotfiles..."
    
    # Create .config if not exists
    mkdir -p "$HOME/.config"
    
    # Link semua config
    for config in "$DOTFILES_DIR/.config"/*; do
        config_name=$(basename "$config")
        target="$HOME/.config/$config_name"
        
        if [ -e "$target" ] || [ -L "$target" ]; then
            rm -rf "$target"
        fi
        
        ln -sf "$config" "$target"
        print_success "Linked $config_name"
    done
}

# Setup SDDM
setup_sddm() {
    print_info "Setting up SDDM..."
    bash "$DOTFILES_DIR/scripts/setup-sddm.sh"
}

# Setup GRUB
setup_grub() {
    print_info "Setting up GRUB..."
    bash "$DOTFILES_DIR/scripts/setup-grub.sh"
}

# Setup Plymouth
setup_plymouth() {
    print_info "Setting up Plymouth..."
    bash "$DOTFILES_DIR/scripts/setup-plymouth.sh"
}

# Enable services
enable_services() {
    print_info "Enabling services..."
    
    sudo systemctl enable sddm.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable bluetooth.service
    
    print_success "Services enabled"
}

# Main installation
main() {
    echo ""
    print_info "Mulai instalasi..."
    echo ""
    
    # Prompt user
    read -p "Backup config yang ada? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        backup_configs
    fi
    
    echo ""
    read -p "Install packages? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_packages
        install_yay
    fi
    
    echo ""
    read -p "Link dotfiles? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        link_dotfiles
    fi
    
    echo ""
    read -p "Setup SDDM? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        setup_sddm
    fi
    
    echo ""
    read -p "Setup GRUB? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        setup_grub
    fi
    
    echo ""
    read -p "Setup Plymouth (boot animation)? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        setup_plymouth
    fi
    
    echo ""
    read -p "Enable services? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        enable_services
    fi
    
    echo ""
    print_success "Instalasi selesai!"
    print_info "Restart system buat apply semua changes"
}

main
