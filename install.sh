#!/bin/bash

# ============================================================================
#  BOBALAND - Arch Linux Hyprland Auto Installer
#  Author: bondanbanuaji
#  Repo: https://github.com/bondanbanuaji/bobaland
#  Dotfiles: https://github.com/bondanbanuaji/Dotfiles
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# Logging
LOG_DIR="$HOME/.cache/bobaland"
LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$LOG_DIR"

log() { echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" | tee -a "$LOG_FILE"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*" | tee -a "$LOG_FILE"; }
log_info() { echo -e "${CYAN}[INFO]${NC} $*" | tee -a "$LOG_FILE"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" | tee -a "$LOG_FILE"; }

# Banner
show_banner() {
    clear
    echo -e "${PURPLE}"
    cat << "EOF"
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠟⠛⠛⠛⠿⠿⢿⣿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⡻⡿⣿⢿⠟⠋⠁⠀⣀⣠⣤⣤⣤⣀⣀⣀⣂⣀⣀⣀⣀⣀⡉⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⢀⢊⠐⠁⠀⠀⣠⣶⡿⠛⣉⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⡔⠑⡀⠀⢀⣤⣾⣟⣫⡴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣷⣄⠈⠙⣟⠼⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⡠⠊⢀⡄⢀⣴⣿⣿⠟⡋⢁⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣷⡄⠈⠰⡔⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⡇⠀⠟⣴⣿⢟⠕⡡⢊⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠘⢄⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢠⢦⡁⠀⠇⢠⣾⣿⡟⣡⣾⣴⣿⣿⢋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠈⢆⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⣾⢸⡇⠀⣴⣿⡿⢉⣼⣿⣿⡟⣼⣣⣾⣿⠿⣿⣿⣿⣿⡿⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣗⠀⣰⠀⠸⢿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢰⣿⢻⢃⣾⣿⡿⠁⣾⣿⣿⣿⢣⢇⣿⣿⠏⡄⣿⣿⣿⣿⡇⣶⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠹⣿⣿⣿⣿⣿⡀⡇⠀⡄⡎⢻⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣾⡿⢠⣿⡟⡼⠁⣸⣿⣿⣿⡏⣾⣿⣿⠏⡼⡇⢻⢻⣿⣿⡇⡿⣧⡘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢻⡇⣿⣿⣿⡇⠁⣼⣷⣷⢸⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢱⡟⣡⣿⢏⣼⠃⣰⣿⣿⣿⣿⢣⣿⣿⡏⣼⣶⣇⢸⠘⣿⣿⡇⣷⡙⣧⡈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⡎⢿⣾⣿⣿⡇⢀⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠊⣼⣿⡏⣾⠃⣰⣿⣿⣿⣿⡿⣸⣿⡟⣠⣭⣭⣋⠈⠀⢿⣿⡇⣽⣿⣎⠻⣄⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⡘⣿⣿⣿⣷⣿⣿⣿⣿⣜⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⠟⢁⡴⣿⡿⣸⠇⣰⣿⣿⣿⣿⣿⢇⣻⡿⣱⣿⣿⣿⣿⣇⠸⡜⣿⡇⢻⣿⣿⣷⢋⣡⠹⣿⣿⣿⣿⣿⣿⣿⣿⣧⢹⣿⣿⣿⣿⣿⣿⣿⡏⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡿⢁⡠⢸⢧⣼⢣⠃⠐⣿⣿⣿⣿⣿⣿⢸⡿⢡⣿⣿⣿⣿⣿⣿⡄⣷⡘⣇⢸⣿⣿⣿⣿⣿⣦⡹⣿⣿⣿⣿⣿⣿⣿⣿⡆⢿⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣯⣶⣿⢇⣿⣼⡏⠄⠐⣸⣿⣿⣿⣿⣿⡇⡾⠁⠛⠿⣿⣿⣿⣿⣿⣿⣿⣷⡈⢸⣿⣿⣿⣿⣿⣿⣷⣘⢿⣿⡟⣿⣿⣿⣿⣿⡘⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⡿⠈⡜⣱⣿⣿⣿⣿⣿⣿⡆⢡⣿⣶⣤⣀⠉⠓⢭⣻⣿⣿⣿⣷⣴⣿⣿⣿⠿⢿⣿⠿⠿⠃⠙⢿⡸⣿⣿⣿⣿⣇⠘⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⠃⠐⣰⡿⠿⢿⣿⣿⣿⣿⡇⢸⡏⣀⣀⣀⣠⣤⣤⣼⣿⣿⣿⣿⣿⣿⣿⠐⠋⠁⢀⣤⣤⣶⣶⣌⢡⢹⣿⡿⠿⡏⣄⠹⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⡇⣿⣿⠀⣴⣿⢣⣿⢸⣿⣿⣿⣿⡇⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣤⣀⡈⠉⣿⢃⣿⣆⠿⠅⣷⢰⣸⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⢰⣿⣣⣾⣿⡿⣼⡏⣼⣿⠏⢹⣿⡇⣶⡜⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⡘⠻⠋⣴⡀⢿⡆⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡟⣸⣿⣿⣿⣿⢡⣿⡇⡿⢡⣾⠇⣿⡇⠻⣿⡜⢿⣿⣿⣿⣿⣿⢛⣛⣛⡻⠿⣿⣿⣿⣿⣿⣿⣿⡿⣡⢠⢱⢘⣗⣿⣿⢸⣷⢸⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⡟⣸⡿⠀⣰⣿⢏⡆⣿⡇⣷⣌⠛⠚⠻⠿⠿⠿⢿⣜⢿⣿⡿⣫⣿⣿⣿⣿⣿⠿⢋⣼⠃⢸⡟⣤⢻⣿⣿⡞⣿⡅⣿⣿⣿⣿⣿⣿⡏⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⢡⣿⣿⣿⣿⢃⣿⡇⣼⣿⡟⣼⣿⢹⡇⣿⣿⣷⣶⡄⠀⠀⠀⠀⢸⣷⣶⣾⣿⣿⣿⠟⣉⣁⣘⣻⣯⠄⡟⣼⣿⣎⢿⣿⣧⢻⣷⠹⣿⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⠏⠜⣛⣱⣶⣂⣾⣿⣧⣿⢍⣰⣿⣿⡎⡇⣿⣿⣿⣿⣿⣧⣿⠈⡻⣮⣙⣛⣭⡽⠖⢑⢡⣿⣿⣿⣿⡟⠘⣼⣿⣿⣿⡜⣟⣿⣼⣿⣧⣲⣦⡙⣛⠪⣁⢻⣿⣿⣿⣿
⣿⣿⣿⣿⡏⡆⢿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣿⠻⢿⣷⡀⣿⣿⣿⠏⡡⣸⣿⣧⣿⣦⠝⠟⣩⣶⣷⣿⣿⣷⡝⠿⣿⣏⣼⣿⣿⡿⢋⢡⣶⣿⣿⣿⣿⣿⣿⣷⣿⡇⣱⢸⣿⣿⣿⣿
⣿⣿⣿⡿⠁⠻⡘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠢⣝⢳⣿⣿⡇⠀⢹⣿⣿⣿⣿⡿⢗⣉⡿⢿⣿⠟⡙⢿⠇⠀⣿⣿⣿⠟⡡⠖⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⣡⢃⡎⣿⣿⣿⣿
⣿⣿⣿⠃⠀⠁⠈⠲⣍⡻⢿⣿⣿⣿⣿⣿⡿⠁⠀⢈⠳⡝⢿⠁⣤⠀⢿⣿⣿⠟⢰⣿⣿⣿⡎⠧⡘⠟⡀⢰⡄⢘⡟⣠⢊⡀⠀⠘⣿⣿⣿⣿⣿⣿⠿⢛⡡⠞⠁⠁⠳⠹⣿⣿⣿
⣿⣿⡏⠀⠀⠀⠀⠀⠀⠉⠓⢮⣍⡛⠿⠟⠁⠀⠀⣼⣷⡝⡄⢸⣿⣦⣈⣡⣴⣶⡈⣿⣿⡟⢴⣤⣄⣄⣠⣾⣷⠄⡸⣡⣾⠆⠀⠀⠈⠻⠿⣛⣩⠴⠚⠉⠀⠀⠀⠀⠀⠃⢻⣿⣿
⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠳⠶⣦⣤⣬⣭⣥⠟⣰⣿⣿⣿⣿⣿⣿⡇⣿⣿⡇⢿⣿⣿⣿⣿⣿⣿⡀⢧⣭⣭⣥⣤⣴⠶⠗⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿
⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠒⠂⣀⠆⣾⣿⣿⣿⣿⣿⣿⣿⡇⣿⣿⣇⢸⣿⣿⣿⣿⣿⣿⣿⣇⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡘⣿
⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⢋⢰⣿⣿⣿⣿⣿⣿⣿⣿⢠⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⣿⣷⠀⢻⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⡸
⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡟⡏⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⢸⣿⡟⠿⠿⠿⠿⠙⣿⡆⠘⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠑
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣧⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⢸⣿⣿⣶⣶⣶⣶⣾⣿⣿⡀⠉⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⡏⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣿⡇⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

╔════════════════════════════════════════════════════════════════════╗
║                                                                    ║
║                                                                    ║
║ ██████╗  ██████╗ ██████╗  █████╗ ██╗      █████╗ ███╗   ██╗██████╗ ║
║ ██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗║
║ ██████╔╝██║   ██║██████╔╝███████║██║     ███████║██╔██╗ ██║██║  ██║║
║ ██╔══██╗██║   ██║██╔══██╗██╔══██║██║     ██╔══██║██║╚██╗██║██║  ██║║
║ ██████╔╝╚██████╔╝██████╔╝██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝║
║ ╚═════╝  ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝ ║
║                                                                    ║
║                  Bobaland - My Arch-Hyprland                       ║
║                     By: Bondan Banuaji                             ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${CYAN}${BOLD}    Arch Linux Hyprland Auto Installer${NC}"
    echo -e "${WHITE}    Author: bondanbanuaji${NC}"
    echo -e "${WHITE}    Repo: https://github.com/bondanbanuaji/bobaland${NC}"
    echo -e "${WHITE}    Dotfiles: https://github.com/bondanbanuaji/Dotfiles${NC}"
    echo ""
}

# Progress bar
progress_bar() {
    local duration=$1
    local message=$2
    local width=50
    echo -ne "${CYAN}${message}${NC} ["
    for ((i=0; i<=width; i++)); do
        echo -ne "${GREEN}▓${NC}"
        sleep $(awk "BEGIN {print $duration/$width}")
    done
    echo -e "] ${GREEN}✓${NC}"
}

# Dependency check
check_dependencies() {
    log_info "Checking dependencies..."
    local deps=("git" "stow" "wget" "curl")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_warn "Missing dependencies: ${missing_deps[*]}"
        echo -e "${YELLOW}Installing missing dependencies...${NC}"
        sudo pacman -S --needed --noconfirm "${missing_deps[@]}"
    fi
    
    log_success "All dependencies satisfied"
}

# Backup configs
backup_configs() {
    local backup_dir="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
    log_info "Creating backup at: $backup_dir"
    mkdir -p "$backup_dir"
    
    # Move configs (instead of cp) to ensure clean slate for stow
    if [ -d "$HOME/.config" ]; then
        log_info "Moving existing ~/.config to backup..."
        mv "$HOME/.config" "$backup_dir/"
        mkdir -p "$HOME/.config"
    fi

    if [ -f "$HOME/.zshrc" ]; then
        mv "$HOME/.zshrc" "$backup_dir/"
    fi
    
    if [ -f "$HOME/.tmux.conf" ]; then
        mv "$HOME/.tmux.conf" "$backup_dir/"
    fi
    
    log_success "Backup created and conflicting files moved to: $backup_dir"
}

# Clone dotfiles
clone_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles"
    local dotfiles_repo="https://github.com/bondanbanuaji/Dotfiles.git"
    
    log_info "Cloning dotfiles repository..."
    
    if [ -d "$dotfiles_dir" ]; then
        log_warn "Dotfiles directory exists. Updating..."
        cd "$dotfiles_dir"
        git pull
    else
        git clone --depth=1 "$dotfiles_repo" "$dotfiles_dir"
    fi
    
    log_success "Dotfiles ready"
}

# Install packages
install_packages() {
    log_info "Installing packages..."
    
    # Main packages
    local packages=(
        "hyprland" "xdg-desktop-portal-hyprland"
        "zsh" "tmux"
        "waybar" "swaync" "rofi-wayland" "wlogout"
        "pipewire" "wireplumber" "cava"
        "ttf-jetbrains-mono-nerd" "ttf-font-awesome" "noto-fonts-emoji"
        "neovim" "stow"
    )

    echo -e "${CYAN}Packages to install:${NC}"
    printf '%s\n' "${packages[@]}" | column
    echo ""
    
    read -p "Continue? [Y/n] " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        # Install main packages
        sudo pacman -S --needed --noconfirm "${packages[@]}"
        
        # Smart terminal install (Ghostty fallback)
        log_info "Installing terminal..."
        if pacman -Si ghostty &>/dev/null; then
            echo -e "${GREEN}Installing Ghostty...${NC}"
            sudo pacman -S --needed --noconfirm ghostty
        else
            log_warn "Ghostty not found in official repos. Installing Kitty as fallback."
            sudo pacman -S --needed --noconfirm kitty
        fi
        
        log_success "Packages installed"
    else
        log_warn "Skipped package installation"
    fi
}

# Deploy dotfiles
deploy_dotfiles() {
    local dotfiles_dir="$HOME/dotfiles"
    log_info "Deploying dotfiles with GNU Stow..."
    cd "$dotfiles_dir"
    
    # Ensure standard directories exist
    mkdir -p "$HOME/.config"
    
    stow -v .
    log_success "Dotfiles deployed"
}

# Setup Zsh
setup_zsh() {
    log_info "Setting up Zsh..."
    
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        log_success "Default shell changed to Zsh"
    fi
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${CYAN}Installing Oh-My-Zsh...${NC}"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
}

# Post-install
post_install() {
    log_info "Running post-install tasks..."
    
    [ -d "$HOME/.config/viegphunt" ] && chmod +x "$HOME/.config/viegphunt"/*
    mkdir -p "$HOME/Pictures/Screenshots" "$HOME/.cache/cava"
    
    log_success "Post-install complete"
}

# Menu
show_menu() {
    echo -e "${BOLD}${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║     Installation Menu                 ║${NC}"
    echo -e "${BOLD}${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}1)${NC} Full Installation (Recommended)"
    echo -e "${WHITE}2)${NC} Install Packages Only"
    echo -e "${WHITE}3)${NC} Deploy Dotfiles Only"
    echo -e "${WHITE}4)${NC} Custom Installation"
    echo -e "${WHITE}5)${NC} Exit"
    echo ""
    read -p "$(echo -e ${CYAN}Select [1-5]: ${NC})" choice
    
    case $choice in
        1) full_installation ;;
        2) install_packages ;;
        3) clone_dotfiles && deploy_dotfiles ;;
        4) custom_installation ;;
        5) exit 0 ;;
        *) log_error "Invalid option"; show_menu ;;
    esac
}

# Full installation
full_installation() {
    log_info "Starting full installation..."
    check_dependencies
    backup_configs
    install_packages
    clone_dotfiles
    deploy_dotfiles
    setup_zsh
    post_install
    show_completion
}

# Custom installation
custom_installation() {
    echo -e "${CYAN}Select components:${NC}"
    echo ""
    
    read -p "Backup configs? [Y/n] " backup
    read -p "Install packages? [Y/n] " packages
    read -p "Deploy dotfiles? [Y/n] " dotfiles
    read -p "Setup Zsh? [Y/n] " zsh
    
    [[ $backup =~ ^[Yy]$ ]] && backup_configs
    [[ $packages =~ ^[Yy]$ ]] && install_packages
    [[ $dotfiles =~ ^[Yy]$ ]] && clone_dotfiles && deploy_dotfiles
    [[ $zsh =~ ^[Yy]$ ]] && setup_zsh
    
    post_install
    show_completion
}

# Completion
show_completion() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║   ✓  Installation Complete!                              ║
    ║                                                           ║
    ║   Your Bobaland Hyprland setup is ready!                ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "  ${WHITE}1.${NC} Logout and login again"
    echo -e "  ${WHITE}2.${NC} Select Hyprland from display manager"
    echo -e "  ${WHITE}3.${NC} Press ${YELLOW}SUPER + H${NC} for keybindings"
    echo ""
    echo -e "${CYAN}Useful commands:${NC}"
    echo -e "  ${WHITE}•${NC} Logs: ${YELLOW}cat $LOG_FILE${NC}"
    echo -e "  ${WHITE}•${NC} Restore: ${YELLOW}cp -r ~/.config-backup-*/.config ~/${NC}"
    echo ""
    echo -e "${GREEN}Enjoy! 🚀${NC}"
}

# Main
main() {
    show_banner
    
    if [ "$EUID" -eq 0 ]; then
        log_error "Don't run as root"
        exit 1
    fi
    
    if [ ! -f /etc/arch-release ]; then
        log_error "Arch Linux only"
        exit 1
    fi
    
    show_menu
}

main "$@"
