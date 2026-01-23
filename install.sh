#!/bin/bash

# ============================================================================
#  BOBALAND - Arch Linux Hyprland Auto Installer
#  Author: bondanbanuaji
#  Repo: https://github.com/bondanbanuaji/bobaland
#  Dotfiles: https://github.com/bondanbanuaji/Dotfiles
#  Version: 1.0.0-rc1
# ============================================================================

set -euo pipefail

# Trap handler for errors and interrupts
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        echo ""
        log_error "Installation interrupted or failed (exit code: $exit_code)"
        log_error "Check log file for details: $LOG_FILE"
        
        if [[ -n "${BACKUP_DIR:-}" ]] && [[ -d "$BACKUP_DIR" ]]; then
            log_info "Your backup is preserved at: $BACKUP_DIR"
            log_info "To restore: Run the restore instructions in the backup directory"
        fi
        
        echo ""
        log_warn "System state may be incomplete. Review the log before retrying."
    fi
    exit $exit_code
}

trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

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

# Command-line flags
DRY_RUN=false
RESUME=false

# Logging setup
LOG_DIR="$HOME/.cache/bobaland"
LOG_FILE="$LOG_DIR/install_$(date +%Y%m%d_%H%M%S).log"
CHECKPOINT_FILE="$LOG_DIR/.checkpoint"
BACKUP_DIR=""
DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_REPO="https://github.com/bondanbanuaji/Dotfiles.git"

mkdir -p "$LOG_DIR"
# Logging functions
log() { 
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${BLUE}[DRY-RUN]${NC} $*"
    else
        echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
    fi
}

log_error() { echo -e "${RED}[ERROR]${NC} $*" | tee -a "$LOG_FILE"; }
log_success() { echo -e "${GREEN}[OK]${NC} $*" | tee -a "$LOG_FILE"; }
log_info() { 
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${BLUE}[PREVIEW]${NC} $*"
    else
        echo -e "${CYAN}[INFO]${NC} $*" | tee -a "$LOG_FILE"
    fi
}
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*" | tee -a "$LOG_FILE"; }

# Checkpoint functions
save_checkpoint() {
    local checkpoint=$1
    if [[ "$DRY_RUN" == "false" ]]; then
        echo "$checkpoint" >> "$CHECKPOINT_FILE"
        log "Checkpoint saved: $checkpoint"
    fi
}

has_checkpoint() {
    local checkpoint=$1
    [[ -f "$CHECKPOINT_FILE" ]] && grep -q "^${checkpoint}$" "$CHECKPOINT_FILE"
}

clear_checkpoints() {
    [[ -f "$CHECKPOINT_FILE" ]] && rm -f "$CHECKPOINT_FILE"
}

# Help function
show_help() {
    cat << 'HELP_EOF'
Bobaland - Arch Linux Hyprland Installer

Usage: ./install.sh [OPTIONS]

Options:
  --dry-run    Preview what will be installed without making changes
  --resume     Resume from last checkpoint (if previous install incomplete)
  --help, -h   Show this help message

Examples:
  ./install.sh              # Run full installation
  ./install.sh --dry-run    # Preview changes
  ./install.sh --resume     # Resume interrupted installation

For more info: https://github.com/bondanbanuaji/bobaland
HELP_EOF
}

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
        sleep "$(awk "BEGIN {print $duration/$width}")"
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

get_dotfiles_targets() {
    # Get list of config directories that dotfiles will deploy
    # This reads the dotfiles structure to determine what will be overwritten
    local targets=()
    
    if [[ -d "$DOTFILES_DIR/.config" ]]; then
        for dir in "$DOTFILES_DIR/.config"/*; do
            if [[ -d "$dir" ]]; then
                targets+=(".config/$(basename "$dir")")
            fi
        done
    fi
    
    # Check for root-level dotfiles
    [[ -f "$DOTFILES_DIR/.zshrc" ]] && targets+=(".zshrc")
    [[ -f "$DOTFILES_DIR/.tmux.conf" ]] && targets+=(".tmux.conf")
    [[ -f "$DOTFILES_DIR/.bashrc" ]] && targets+=(".bashrc")
    [[ -d "$DOTFILES_DIR/.local" ]] && targets+=(".local")
    
    printf '%s\n' "${targets[@]}"
}

backup_configs() {
    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
    log_info "Creating selective backup at: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    # Create restore script
    cat > "$BACKUP_DIR/RESTORE.sh" << 'RESTORE_EOF'
#!/bin/bash
# Bobaland Backup Restore Script
# Run this script to restore your backed up configurations

BACKUP_DIR="$(dirname "$(readlink -f "$0")")"
echo "Restoring configurations from: $BACKUP_DIR"

if [[ -f "$BACKUP_DIR/manifest.txt" ]]; then
    while IFS= read -r item; do
        src="$BACKUP_DIR/$item"
        dest="$HOME/$item"
        if [[ -e "$src" ]]; then
            echo "Restoring: $item"
            mkdir -p "$(dirname "$dest")"
            rm -rf "$dest"
            cp -r "$src" "$dest"
        fi
    done < "$BACKUP_DIR/manifest.txt"
    echo "Restore complete!"
else
    echo "ERROR: manifest.txt not found. Manual restore required."
    exit 1
fi
RESTORE_EOF
    chmod +x "$BACKUP_DIR/RESTORE.sh"
    
    # First, check if dotfiles exists to determine what to backup
    local backed_up=0
    local manifest_file="$BACKUP_DIR/manifest.txt"
    > "$manifest_file"  # Create empty manifest
    
    if [[ -d "$DOTFILES_DIR" ]]; then
        # Selective backup based on dotfiles content
        log_info "Analyzing dotfiles for selective backup..."
        
        while IFS= read -r target; do
            local src="$HOME/$target"
            if [[ -e "$src" ]]; then
                log_info "  Backing up: $target"
                mkdir -p "$BACKUP_DIR/$(dirname "$target")"
                cp -r "$src" "$BACKUP_DIR/$target"
                echo "$target" >> "$manifest_file"
                ((backed_up++))
            fi
        done < <(get_dotfiles_targets)
    else
        # Dotfiles not yet cloned - backup common Hyprland configs
        log_info "Dotfiles not yet cloned, backing up common Hyprland configs..."
        
        local common_configs=(
            ".config/hypr"
            ".config/waybar"
            ".config/rofi"
            ".config/swaync"
            ".config/wlogout"
            ".config/kitty"
            ".config/foot"
            ".config/alacritty"
            ".config/ghostty"
            ".config/cava"
            ".config/neovim"
            ".config/nvim"
            ".zshrc"
            ".tmux.conf"
        )
        
        for target in "${common_configs[@]}"; do
            local src="$HOME/$target"
            if [[ -e "$src" ]]; then
                log_info "  Backing up: $target"
                mkdir -p "$BACKUP_DIR/$(dirname "$target")"
                cp -r "$src" "$BACKUP_DIR/$target"
                echo "$target" >> "$manifest_file"
                ((backed_up++))
            fi
        done
    fi
    
    if [[ $backed_up -eq 0 ]]; then
        log_info "No existing configs to backup"
        rm -rf "$BACKUP_DIR"
        BACKUP_DIR=""
    else
        log_success "Backed up $backed_up item(s) to: $BACKUP_DIR"
        log_info "To restore: run $BACKUP_DIR/RESTORE.sh"
    fi
}

# Clone dotfiles
clone_dotfiles() {
    log_info "Cloning dotfiles repository..."
    
    if [[ -d "$DOTFILES_DIR" ]]; then
        log_warn "Dotfiles directory exists. Updating..."
        cd "$DOTFILES_DIR"
        if ! git pull --ff-only 2>/dev/null; then
            log_warn "Could not fast-forward. Stashing local changes..."
            git stash
            git pull
        fi
    else
        if ! git clone --depth=1 "$DOTFILES_REPO" "$DOTFILES_DIR"; then
            log_error "Failed to clone dotfiles repository"
            log_error "Check your network connection and try again"
            exit 1
        fi
    fi
    
    log_success "Dotfiles ready"
}

# Install packages
install_packages() {
    log_info "Installing packages..."
    
    local packages=(
        # Core Hyprland
        "hyprland"
        "xdg-desktop-portal-hyprland"
        "xdg-desktop-portal-gtk"
        # UI components
        "waybar"
        "swaync"
        "rofi-wayland"
        "wlogout"
        # Terminal & shell
        "zsh"
        "tmux"
        "stow"
        # Audio
        "pipewire"
        "wireplumber"
        "pipewire-pulse"
        "cava"
        # Fonts
        "ttf-jetbrains-mono-nerd"
        "ttf-font-awesome"
        "noto-fonts-emoji"
        # Tools
        "neovim"
    )

    echo -e "${CYAN}Packages to install:${NC}"
    printf '%s\n' "${packages[@]}" | column
    echo ""
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "Dry-run mode: packages listed above would be installed"
        return 0
    fi
    
    read -p "Continue? [Y/n] " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        # Install main packages
        sudo pacman -S --needed --noconfirm "${packages[@]}"
        
        # Terminal installation with fallback chain (per audit Section 4)
        log_info "Installing terminal emulator..."
        install_terminal
        
        log_success "Packages installed"
    else
        log_warn "Skipped package installation"
    fi

}

# Terminal installation with fallback chain
install_terminal() {
    local terminals=("ghostty" "foot" "kitty" "alacritty")
    
    for term in "${terminals[@]}"; do
        if pacman -Si "$term" &>/dev/null; then
            log_info "Installing $term..."
            if sudo pacman -S --needed --noconfirm "$term"; then
                log_success "Installed terminal: $term"
                return 0
            fi
        else
            log_warn "$term not available in repos, trying next..."
        fi
    done
    
    log_error "No terminal emulator could be installed!"
    log_error "Please install a terminal manually (ghostty, foot, kitty, or alacritty)"
    return 1
}


check_stow_conflicts() {
    log_info "Checking for stow conflicts..."
    cd "$DOTFILES_DIR"
    
    # Run stow in simulate mode to detect conflicts
    local conflicts
    if ! conflicts=$(stow --simulate -v . 2>&1); then
        if echo "$conflicts" | grep -q "CONFLICT"; then
            log_warn "Stow detected conflicts:"
            echo "$conflicts" | grep "CONFLICT" | while read -r line; do
                log_warn "  $line"
            done
            return 1
        fi
    fi
    
    log_success "No stow conflicts detected"
    return 0
}

resolve_stow_conflicts() {
    log_info "Resolving stow conflicts..."
    cd "$DOTFILES_DIR"
    
    # Get list of conflicts
    local conflicts
    conflicts=$(stow --simulate -v . 2>&1 | grep "CONFLICT" || true)
    
    if [[ -z "$conflicts" ]]; then
        return 0
    fi
    
    echo -e "${YELLOW}The following files conflict with dotfiles:${NC}"
    echo "$conflicts"
    echo ""
    echo -e "${CYAN}Options:${NC}"
    echo "  1) Backup conflicts and continue (recommended)"
    echo "  2) Skip dotfiles deployment"
    echo "  3) Force overwrite (not recommended)"
    echo ""
    read -p "Select [1-3]: " -n 1 -r choice
    echo
    
    case $choice in
        1)
            # Backup conflicting files
            local conflict_backup="$BACKUP_DIR/stow-conflicts"
            mkdir -p "$conflict_backup"
            
            echo "$conflicts" | while read -r line; do
                # Extract file path from conflict message
                local file
                file=$(echo "$line" | grep -oP '(?<=existing target is neither a link nor a directory: ).*' || true)
                if [[ -n "$file" ]] && [[ -e "$HOME/$file" ]]; then
                    log_info "  Moving conflict: $file"
                    mkdir -p "$conflict_backup/$(dirname "$file")"
                    mv "$HOME/$file" "$conflict_backup/$file"
                fi
            done
            log_success "Conflicts backed up to: $conflict_backup"
            ;;
        2)
            log_warn "Skipping dotfiles deployment"
            return 1
            ;;
        3)
            log_warn "Force overwrite selected - existing files will be removed"
            read -p "Type 'yes' to confirm: " confirm
            if [[ "$confirm" != "yes" ]]; then
                log_warn "Cancelled"
                return 1
            fi
            # Remove conflicting files
            echo "$conflicts" | while read -r line; do
                local file
                file=$(echo "$line" | grep -oP '(?<=existing target is neither a link nor a directory: ).*' || true)
                if [[ -n "$file" ]] && [[ -e "$HOME/$file" ]]; then
                    rm -rf "$HOME/${file:?}"
                fi
            done
            ;;
        *)
            log_error "Invalid option"
            return 1
            ;;
    esac
    
    return 0
}

# Deploy dotfiles with conflict handling
deploy_dotfiles() {
    log_info "Deploying dotfiles with GNU Stow..."
    cd "$DOTFILES_DIR"
    
    # Ensure .config exists
    mkdir -p "$HOME/.config"
    
    # Check for conflicts first
    if ! check_stow_conflicts; then
        if ! resolve_stow_conflicts; then
            log_error "Could not resolve stow conflicts"
            return 1
        fi
    fi
    
    # Deploy with stow
    if stow -v .; then
        log_success "Dotfiles deployed successfully"
    else
        log_error "Stow deployment failed"
        return 1
    fi
}


setup_zsh() {
    log_info "Setting up Zsh..."
    
    # Verify Zsh is installed and working
    if ! command -v zsh &> /dev/null; then
        log_error "Zsh is not installed!"
        return 1
    fi
    
    # Test Zsh can actually run
    if ! zsh -c 'echo "Zsh test successful"' &>/dev/null; then
        log_error "Zsh failed to execute properly"
        return 1
    fi
    
    # Save current shell for potential rollback
    local current_shell
    current_shell=$(getent passwd "$USER" | cut -d: -f7)
    echo "$current_shell" > "$LOG_DIR/.previous_shell"
    
    if [[ "$current_shell" != "$(which zsh)" ]]; then
        log_info "Changing default shell to Zsh..."
        log_info "Current shell saved to: $LOG_DIR/.previous_shell"
        
        if chsh -s "$(which zsh)"; then
            log_success "Default shell changed to Zsh"
        else
            log_error "Failed to change shell. You can do this manually with: chsh -s $(which zsh)"
        fi
    else
        log_info "Zsh is already the default shell"
    fi
    
    # Oh-My-Zsh installation with safety checks
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh-My-Zsh..."
        
        # Download with timeout
        local omz_script="/tmp/ohmyzsh-install-$$.sh"
        if curl -fsSL --connect-timeout 10 --max-time 60 \
            "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" \
            -o "$omz_script"; then
            
            # Run unattended
            if sh "$omz_script" "" --unattended; then
                log_success "Oh-My-Zsh installed"
            else
                log_warn "Oh-My-Zsh installation failed, but continuing..."
            fi
            rm -f "$omz_script"
        else
            log_warn "Could not download Oh-My-Zsh installer. Skipping..."
        fi
    else
        log_info "Oh-My-Zsh already installed"
    fi
}


setup_audio() {
    log_info "Setting up audio (PipeWire)..."
    
    # Check for PulseAudio conflict
    if systemctl --user is-active pulseaudio.service &>/dev/null; then
        log_warn "PulseAudio is running. Disabling in favor of PipeWire..."
        systemctl --user disable --now pulseaudio.service pulseaudio.socket 2>/dev/null || true
    fi
    
    # Enable PipeWire user services
    local services=("pipewire" "pipewire-pulse" "wireplumber")
    
    for service in "${services[@]}"; do
        if systemctl --user enable "$service.service" 2>/dev/null; then
            log_success "Enabled: $service"
        else
            log_warn "Could not enable $service (may not be installed)"
        fi
    done
    
    # Start services if in graphical session
    if [[ -n "${DISPLAY:-}" ]] || [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
        for service in "${services[@]}"; do
            systemctl --user start "$service.service" 2>/dev/null || true
        done
        
        # Verify audio
        if command -v wpctl &>/dev/null; then
            if wpctl status &>/dev/null; then
                log_success "Audio system verified"
            else
                log_warn "Audio verification incomplete - will work after reboot"
            fi
        fi
    else
        log_info "Audio services will start after login to graphical session"
    fi
}


detect_display_manager() {
    local dm_services=("sddm" "gdm" "lightdm" "ly" "greetd")
    
    for dm in "${dm_services[@]}"; do
        if systemctl is-enabled "${dm}.service" &>/dev/null; then
            echo "$dm"
            return 0
        fi
    done
    
    echo "none"
    return 1
}

setup_display_manager() {
    log_info "Checking display manager status..."
    
    local current_dm
    current_dm=$(detect_display_manager)
    
    if [[ "$current_dm" != "none" ]]; then
        log_success "Display manager detected: $current_dm"
        
        # Verify Hyprland session file exists
        if [[ -f "/usr/share/wayland-sessions/hyprland.desktop" ]]; then
            log_success "Hyprland session file found"
        else
            log_warn "Hyprland session file not found - may need manual configuration"
        fi
        return 0
    fi
    
    # No display manager - this is CRITICAL per audit
    log_warn "No display manager detected!"
    echo ""
    echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║  WARNING: No Display Manager Found                         ║${NC}"
    echo -e "${YELLOW}║                                                            ║${NC}"
    echo -e "${YELLOW}║  Without a display manager, you will need to start         ║${NC}"
    echo -e "${YELLOW}║  Hyprland manually from TTY after boot.                    ║${NC}"
    echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Options:${NC}"
    echo "  1) Install SDDM (recommended for Hyprland)"
    echo "  2) Install GDM (GNOME display manager)"
    echo "  3) Skip - I will start Hyprland manually"
    echo ""
    read -p "Select [1-3]: " -n 1 -r choice
    echo
    
    case $choice in
        1)
            log_info "Installing SDDM..."
            if sudo pacman -S --needed --noconfirm sddm; then
                sudo systemctl enable sddm.service
                log_success "SDDM installed and enabled"
            else
                log_error "Failed to install SDDM"
                create_tty_start_script
            fi
            ;;
        2)
            log_info "Installing GDM..."
            if sudo pacman -S --needed --noconfirm gdm; then
                sudo systemctl enable gdm.service
                log_success "GDM installed and enabled"
            else
                log_error "Failed to install GDM"
                create_tty_start_script
            fi
            ;;
        3)
            log_info "Skipping display manager installation"
            create_tty_start_script
            ;;
        *)
            log_warn "Invalid option, creating manual start script"
            create_tty_start_script
            ;;
    esac
}

create_tty_start_script() {
    log_info "Creating manual Hyprland start script..."
    
    # Create start script
    cat > "$HOME/.start-hyprland" << 'START_EOF'
#!/bin/bash
# Bobaland - Manual Hyprland Start Script
# Run this from TTY to start Hyprland

# Check if already in graphical session
if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
    echo "Already in a Wayland session!"
    exit 1
fi

# Set required environment variables
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export XDG_CURRENT_DESKTOP=Hyprland

# Start Hyprland
echo "Starting Hyprland..."
exec Hyprland
START_EOF
    chmod +x "$HOME/.start-hyprland"
    
    # Add to .zprofile or .bash_profile for auto-start option
    local profile_file="$HOME/.zprofile"
    [[ ! -f "$profile_file" ]] && profile_file="$HOME/.bash_profile"
    
    if [[ -f "$profile_file" ]] && ! grep -q "start-hyprland" "$profile_file"; then
        cat >> "$profile_file" << 'PROFILE_EOF'

# Auto-start Hyprland on TTY1 (added by Bobaland installer)
if [[ -z "${DISPLAY:-}" ]] && [[ -z "${WAYLAND_DISPLAY:-}" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
    echo "Press Enter to start Hyprland, or wait 5 seconds to stay in TTY..."
    read -t 5 -p "" && exec ~/.start-hyprland
fi
PROFILE_EOF
        log_info "Added auto-start prompt to $profile_file"
    fi
    
    log_success "Created: ~/.start-hyprland"
    log_info "After reboot, login to TTY1 and run: ~/.start-hyprland"
}

# Post-install
post_install() {
    log_info "Running post-install tasks..."
    
    # Make scripts executable
    [[ -d "$HOME/.config/viegphunt" ]] && chmod +x "$HOME/.config/viegphunt"/* 2>/dev/null || true
    
    # Create necessary directories
    mkdir -p "$HOME/Pictures/Screenshots" "$HOME/.cache/cava"
    
    # Setup audio
    setup_audio
    
    # Setup display manager
    setup_display_manager
    
    log_success "Post-install complete"
}

# Menu
show_menu() {
    echo -e "${BOLD}${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${CYAN}║     Installation Menu                  ║${NC}"
    echo -e "${BOLD}${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${WHITE}1)${NC} Full Installation (Recommended)"
    echo -e "${WHITE}2)${NC} Install Packages Only"
    echo -e "${WHITE}3)${NC} Deploy Dotfiles Only"
    echo -e "${WHITE}4)${NC} Custom Installation"
    echo -e "${WHITE}5)${NC} Exit"
    echo ""
    read -p "$(echo -e "${CYAN}Select [1-5]: ${NC}")" choice
    
    case $choice in
        1) full_installation ;;
        2) install_packages ;;
        3) clone_dotfiles && deploy_dotfiles ;;
        4) custom_installation ;;
        5) exit 0 ;;
        *) log_error "Invalid option"; show_menu ;;
    esac
}

# Full installation with checkpoint support
full_installation() {
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${BOLD}${BLUE}═══════════════════════════════════════════${NC}"
        echo -e "${BOLD}${BLUE}  DRY-RUN MODE - Preview Only${NC}"
        echo -e "${BOLD}${BLUE}═══════════════════════════════════════════${NC}"
        echo ""
    fi
    
    log_info "Starting full installation..."
    
    if [[ "$DRY_RUN" == "false" ]]; then
        log "Installation started at $(date)"
    fi
    
    # Check for resume
    if [[ "$RESUME" == "true" ]] && [[ -f "$CHECKPOINT_FILE" ]]; then
        log_info "Resuming from previous installation..."
        log_info "Previously completed steps:"
        cat "$CHECKPOINT_FILE" | while read -r step; do
            log_success "  ✓ $step"
        done
        echo ""
    fi
    
    # Step 1: Dependencies
    if ! has_checkpoint "DEPS_CHECKED"; then
        check_dependencies
        save_checkpoint "DEPS_CHECKED"
    else
        log_info "Skipping dependencies check (already done)"
    fi
    
    # Step 2: Backup
    if ! has_checkpoint "CONFIGS_BACKED_UP"; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "Would create selective backup of existing configs"
        else
            backup_configs
        fi
        save_checkpoint "CONFIGS_BACKED_UP"
    else
        log_info "Skipping backup (already done)"
    fi
    
    # Step 3: Packages
    if ! has_checkpoint "PACKAGES_INSTALLED"; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "Would install Hyprland and components"
            install_packages  # Will show list but not install
        else
            install_packages
        fi
        save_checkpoint "PACKAGES_INSTALLED"
    else
        log_info "Skipping package installation (already done)"
    fi
    
    # Step 4: Clone dotfiles
    if ! has_checkpoint "DOTFILES_CLONED"; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "Would clone dotfiles from: $DOTFILES_REPO"
        else
            clone_dotfiles
        fi
        save_checkpoint "DOTFILES_CLONED"
    else
        log_info "Skipping dotfiles clone (already done)"
    fi
    
    # Step 5: Deploy dotfiles
    if ! has_checkpoint "DOTFILES_DEPLOYED"; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "Would deploy dotfiles with GNU Stow"
        else
            deploy_dotfiles
        fi
        save_checkpoint "DOTFILES_DEPLOYED"
    else
        log_info "Skipping dotfiles deployment (already done)"
    fi
    
    # Step 6: Setup Zsh
    if ! has_checkpoint "ZSH_CONFIGURED"; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "Would setup Zsh and Oh-My-Zsh"
        else
            setup_zsh
        fi
        save_checkpoint "ZSH_CONFIGURED"
    else
        log_info "Skipping Zsh setup (already done)"
    fi
    
    # Step 7: Post-install
    if ! has_checkpoint "POST_INSTALL_DONE"; then
        if [[ "$DRY_RUN" == "true" ]]; then
            log_info "Would run post-install tasks (audio, display manager)"
        else
            post_install
        fi
        save_checkpoint "POST_INSTALL_DONE"
    else
        log_info "Skipping post-install (already done)"
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        echo ""
        echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║  Dry-run complete! No changes were made.             ║${NC}"
        echo -e "${GREEN}║                                                       ║${NC}"
        echo -e "${GREEN}║  Run without --dry-run to perform actual installation║${NC}"
        echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    else
        # Clear checkpoints on successful completion
        clear_checkpoints
        show_completion
    fi
}


# Custom installation
custom_installation() {
    echo -e "${CYAN}Select components to install:${NC}"
    echo ""
    
    read -p "Backup existing configs? [Y/n] " -r backup_choice
    read -p "Install packages? [Y/n] " -r packages_choice
    read -p "Deploy dotfiles? [Y/n] " -r dotfiles_choice
    read -p "Setup Zsh? [Y/n] " -r zsh_choice
    
    [[ ! $backup_choice =~ ^[Nn]$ ]] && backup_configs
    [[ ! $packages_choice =~ ^[Nn]$ ]] && install_packages
    [[ ! $dotfiles_choice =~ ^[Nn]$ ]] && { clone_dotfiles && deploy_dotfiles; }
    [[ ! $zsh_choice =~ ^[Nn]$ ]] && setup_zsh
    
    post_install
    show_completion
}

# Completion message
show_completion() {
    local dm
    dm=$(detect_display_manager)
    
    clear
    echo -e "${GREEN}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║   ✓  Installation Complete!                               ║
    ║                                                           ║
    ║   Your Bobaland Hyprland setup is ready!                  ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${CYAN}Next steps:${NC}"
    echo -e "  ${WHITE}1.${NC} Logout and login again (or reboot)"
    
    if [[ "$dm" != "none" ]]; then
        echo -e "  ${WHITE}2.${NC} Select ${YELLOW}Hyprland${NC} from your display manager ($dm)"
    else
        echo -e "  ${WHITE}2.${NC} Login to TTY1 and run: ${YELLOW}~/.start-hyprland${NC}"
    fi
    
    echo -e "  ${WHITE}3.${NC} Press ${YELLOW}SUPER + H${NC} for keybindings"
    echo ""
    
    echo -e "${CYAN}Useful info:${NC}"
    echo -e "  ${WHITE}•${NC} Logs: ${YELLOW}$LOG_FILE${NC}"
    
    if [[ -n "$BACKUP_DIR" ]]; then
        echo -e "  ${WHITE}•${NC} Restore backup: ${YELLOW}$BACKUP_DIR/RESTORE.sh${NC}"
    fi
    
    if [[ -f "$LOG_DIR/.previous_shell" ]]; then
        local prev_shell
        prev_shell=$(cat "$LOG_DIR/.previous_shell")
        echo -e "  ${WHITE}•${NC} Previous shell: ${YELLOW}$prev_shell${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}Enjoy your new setup! 🚀${NC}"
    
    # Log completion
    log "Installation completed successfully at $(date)"
}

# Main entry point
main() {
    # Parse command-line arguments first
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --resume)
                RESUME=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    show_banner
    
    # Safety checks
    if [[ "$EUID" -eq 0 ]]; then
        log_error "Don't run this script as root!"
        log_error "Run as your normal user. Sudo will be requested when needed."
        exit 1
    fi
    
    if [[ ! -f /etc/arch-release ]]; then
        log_error "This installer is designed for Arch Linux only"
        exit 1
    fi
    
    log "Bobaland installer started - Version 1.0.0-rc1"
    log "User: $USER, Home: $HOME"
    log "Log file: $LOG_FILE"
    
    show_menu
}

main "$@"
