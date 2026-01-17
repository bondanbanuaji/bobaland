#!/bin/bash

# Bobaland Dotfiles Installer
# https://github.com/bondanbanuaji/bobaland

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Directories
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/.config"
SCRIPTS_DIR="$DOTFILES_DIR/scripts"
ASSETS_DIR="$DOTFILES_DIR/assets"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

# Flags
DRY_RUN=false
NO_BACKUP=false

# Helper Functions
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_info() { echo -e "${BLUE}[i]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_header() { echo -e "\n${CYAN}=== $1 ===${NC}\n"; }

usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --dry-run    Preview changes without applying"
    echo "  --no-backup  Skip backing up existing configs"
    exit 0
}

# Parse Args
for arg in "$@"; do
    case $arg in
        --dry-run) DRY_RUN=true ;;
        --no-backup) NO_BACKUP=true ;;
        --help) usage ;;
    esac
done

# Main Logic
banner() {
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════╗
║       Bobaland Dotfiles Setup         ║
║          Arch Linux Edition           ║
╚═══════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

backup_configs() {
    if [ "$NO_BACKUP" = true ]; then return; fi
    print_header "Backing up configurations"
    
    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would backup .config to $BACKUP_DIR"
        return
    fi

    mkdir -p "$BACKUP_DIR"
    print_info "Creating backup at $BACKUP_DIR..."
    
    # Backup relevant configs only to save space/time, or just backup whole .config?
    # Backing up individual conflicts is safer.
    for config in "$CONFIG_DIR"/*; do
        target="$HOME/.config/$(basename "$config")"
        if [ -e "$target" ]; then
            cp -r "$target" "$BACKUP_DIR/"
            print_success "Backed up $(basename "$config")"
        fi
    done
}

install_packages() {
    print_header "Installing Packages"
    
    # Check for packages.txt
    PACKAGES_FILE="$SCRIPTS_DIR/packages.txt"
    if [ ! -f "$PACKAGES_FILE" ]; then
        print_warning "packages.txt not found in $SCRIPTS_DIR. Skipping package installation."
        return
    fi

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would install packages from $PACKAGES_FILE"
        return
    fi

    # Read and install
    sudo pacman -Syu --noconfirm
    
    # Check for yay
    if ! command -v yay &> /dev/null; then
        print_info "Installing yay..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd "$DOTFILES_DIR"
    fi

    print_info "Installing official and AUR packages..."
    yay -S --needed --noconfirm - < "$PACKAGES_FILE"
    print_success "Packages installed."
}

link_configs() {
    print_header "Linking Configuration Files"
    
    mkdir -p "$HOME/.config"

    for config in "$CONFIG_DIR"/*; do
        name=$(basename "$config")
        target="$HOME/.config/$name"
        
        if [ "$DRY_RUN" = true ]; then
            print_info "[DRY RUN] Would link $name -> $target"
            continue
        fi

        # Remove existing config if it exists (backup handled previously)
        if [ -e "$target" ] || [ -L "$target" ]; then
            rm -rf "$target"
        fi

        ln -sf "$config" "$target"
        print_success "Linked $name"
    done
}

setup_assets() {
    print_header "Setting up Assets"
    
    # Wallpapers
    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would run setup-wallpapers.sh"
    else
        bash "$SCRIPTS_DIR/setup-wallpapers.sh"
    fi
}

run_scripts() {
    print_header "Running System Setup Scripts"
    
    scripts=("setup-grub.sh" "setup-plymouth.sh" "setup-sddm.sh")
    
    for script in "${scripts[@]}"; do
        script_path="$SCRIPTS_DIR/$script"
        
        if [ ! -f "$script_path" ]; then continue; fi

        echo -n "Run $script? (y/n) "
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            if [ "$DRY_RUN" = true ]; then
                print_info "[DRY RUN] Would execute $script_path"
            else
                print_info "Executing $script..."
                # These scripts usually require root, so we invoke with sudo if needed inside user prompt or here?
                # Best to run with sudo here if script handles it, but my scripts check if root.
                # So we should run them with sudo.
                sudo bash "$script_path"
            fi
        fi
    done
}

main() {
    banner
    if [ "$DRY_RUN" = true ]; then print_warning "DRY RUN MODE ACTIVE"; fi
    
    # Check requirements
    if [ ! -d "$CONFIG_DIR" ]; then print_error "Configuration directory not found!"; exit 1; fi

    # Confirm
    echo "This script will overwrite your existing configurations."
    echo -n "Continue? (y/n) "
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then exit 0; fi

    backup_configs
    
    echo -n "Install packages? (y/n) "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then install_packages; fi
    
    link_configs
    
    # Wallpapers are safe to always install if folder exists? asking is better.
    echo -n "Install wallpapers? (y/n) "
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then setup_assets; fi

    run_scripts

    print_header "Installation Complete!"
    print_info "Please reboot your system."
}

main
