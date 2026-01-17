#!/usr/bin/env bash

# ============================================
# bobaland - Utility Functions Library
# ============================================
# Shared functions for all installation scripts
# Provides logging, error handling, user prompts, and more
#
# Usage: source "$(dirname "$0")/utils.sh"
# ============================================

# ============================================
# COLORS & FORMATTING
# ============================================

# ANSI color codes
readonly COLOR_RESET='\033[0m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_MAGENTA='\033[0;35m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_WHITE='\033[0;37m'
readonly COLOR_BOLD='\033[1m'

# ============================================
# LOGGING FUNCTIONS
# ============================================

# Log file location
readonly LOG_DIR="${HOME}/.local/share/bobaland"
readonly LOG_FILE="${LOG_DIR}/install.log"

# Initialize logging
init_logging() {
    mkdir -p "$LOG_DIR"
    echo "=== bobaland Installation Log ===" > "$LOG_FILE"
    echo "Date: $(date)" >> "$LOG_FILE"
    echo "User: $USER" >> "$LOG_FILE"
    echo "=================================" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
}

# Log to file
log_to_file() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# Info message (blue)
log_info() {
    echo -e "${COLOR_BLUE}${COLOR_BOLD}[INFO]${COLOR_RESET} $*"
    log_to_file "INFO: $*"
}

# Success message (green)
log_success() {
    echo -e "${COLOR_GREEN}${COLOR_BOLD}[✓]${COLOR_RESET} $*"
    log_to_file "SUCCESS: $*"
}

# Warning message (yellow)
log_warning() {
    echo -e "${COLOR_YELLOW}${COLOR_BOLD}[WARNING]${COLOR_RESET} $*"
    log_to_file "WARNING: $*"
}

# Error message (red)
log_error() {
    echo -e "${COLOR_RED}${COLOR_BOLD}[ERROR]${COLOR_RESET} $*" >&2
    log_to_file "ERROR: $*"
}

# Step message (cyan)
log_step() {
    echo -e "${COLOR_CYAN}${COLOR_BOLD}[STEP]${COLOR_RESET} $*"
    log_to_file "STEP: $*"
}

# Header message
log_header() {
    echo ""
    echo -e "${COLOR_MAGENTA}${COLOR_BOLD}========================================${COLOR_RESET}"
    echo -e "${COLOR_MAGENTA}${COLOR_BOLD} $*${COLOR_RESET}"
    echo -e "${COLOR_MAGENTA}${COLOR_BOLD}========================================${COLOR_RESET}"
    echo ""
    log_to_file "HEADER: $*"
}

# ============================================
# ERROR HANDLING
# ============================================

# Exit with error
die() {
    log_error "$*"
    log_error "Installation failed. Check log: $LOG_FILE"
    exit 1
}

# Check last command status
check_status() {
    local status=$?
    local message=$1
    
    if [ $status -ne 0 ]; then
        die "$message (exit code: $status)"
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Check if running as root
check_not_root() {
    if [ "$EUID" -eq 0 ]; then
        die "Do not run this script as root! Run as your regular user."
    fi
}

# Check if sudo is available
check_sudo() {
    if ! command_exists sudo; then
        die "sudo is required but not installed."
    fi
    
    # Test sudo access
    if ! sudo -v &> /dev/null; then
        die "sudo access required. Please configure sudo for your user."
    fi
}

# ============================================
# USER INTERACTION
# ============================================

# Ask yes/no question
# Returns 0 for yes, 1 for no
ask_yes_no() {
    local prompt="$1"
    local default="${2:-n}" # default to 'n' if not specified
    local response
    
    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi
    
    while true; do
        read -r -p "$prompt" response
        response=${response:-$default}
        
        case "${response,,}" in # Convert to lowercase
            y|yes)
                return 0
                ;;
            n|no)
                return 1
                ;;
            *)
                echo "Please answer yes or no."
                ;;
        esac
    done
}

# Confirm action or exit
confirm_or_exit() {
    local message="$1"
    
    if ! ask_yes_no "$message"; then
        log_warning "Operation cancelled by user."
        exit 0
    fi
}

# Press any key to continue
press_any_key() {
    local message="${1:-Press any key to continue...}"
    read -n 1 -s -r -p "$message"
    echo ""
}

# ============================================
# PROGRESS INDICATORS
# ============================================

# Spinner animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    
    while ps -p "$pid" &> /dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Run command with spinner
run_with_spinner() {
    local message="$1"
    shift
    
    echo -n "$message... "
    
    "$@" &> /dev/null &
    local pid=$!
    spinner $pid
    wait $pid
    local status=$?
    
    if [ $status -eq 0 ]; then
        echo -e "${COLOR_GREEN}✓${COLOR_RESET}"
    else
        echo -e "${COLOR_RED}✗${COLOR_RESET}"
        return $status
    fi
}

# ============================================
# FILE OPERATIONS
# ============================================

# Create backup of file/directory
backup_file() {
    local source="$1"
    local backup_dir="${HOME}/bobaland/backup"
    
    if [ ! -e "$source" ]; then
        log_info "No existing file to backup: $source"
        return 0
    fi
    
    mkdir -p "$backup_dir"
    
    local basename=$(basename "$source")
    local backup_path="${backup_dir}/${basename}.$(date +%Y%m%d-%H%M%S)"
    
    log_info "Backing up: $source -> $backup_path"
    cp -r "$source" "$backup_path"
    check_status "Failed to backup $source"
    
    log_success "Backup created: $backup_path"
}

# Create symlink safely
create_symlink() {
    local source="$1"
    local target="$2"
    
    # Check if source exists
    if [ ! -e "$source" ]; then
        log_error "Source does not exist: $source"
        return 1
    fi
    
    # If target exists and is not a symlink, backup
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        backup_file "$target"
        rm -rf "$target"
    fi
    
    # If target is a symlink, remove it
    if [ -L "$target" ]; then
        rm "$target"
    fi
    
    # Create parent directory if needed
    local target_dir=$(dirname "$target")
    mkdir -p "$target_dir"
    
    # Create symlink
    ln -sf "$source" "$target"
    check_status "Failed to create symlink: $source -> $target"
    
    log_success "Created symlink: $target -> $source"
}

# ============================================
# PACKAGE MANAGEMENT
# ============================================

# Check if package is installed
is_package_installed() {
    local package="$1"
    pacman -Q "$package" &> /dev/null
}

# Install package if not already installed
install_package() {
    local package="$1"
    
    if is_package_installed "$package"; then
        log_info "Package already installed: $package"
        return 0
    fi
    
    log_step "Installing package: $package"
    sudo pacman -S --noconfirm "$package"
    check_status "Failed to install package: $package"
    
    log_success "Installed: $package"
}

# Install multiple packages
install_packages() {
    local packages=("$@")
    
    if [ ${#packages[@]} -eq 0 ]; then
        log_warning "No packages to install"
        return 0
    fi
    
    log_step "Installing ${#packages[@]} packages..."
    
    # Filter out already installed packages
    local to_install=()
    for package in "${packages[@]}"; do
        if ! is_package_installed "$package"; then
            to_install+=("$package")
        fi
    done
    
    if [ ${#to_install[@]} -eq 0 ]; then
        log_success "All packages already installed"
        return 0
    fi
    
    log_info "Installing: ${to_install[*]}"
    sudo pacman -S --noconfirm "${to_install[@]}"
    check_status "Failed to install packages"
    
    log_success "Installed ${#to_install[@]} packages"
}

# Check if AUR helper is installed
has_aur_helper() {
    command_exists yay || command_exists paru
}

# Get AUR helper name
get_aur_helper() {
    if command_exists yay; then
        echo "yay"
    elif command_exists paru; then
        echo "paru"
    else
        echo ""
    fi
}

# Install AUR package
install_aur_package() {
    local package="$1"
    local aur_helper=$(get_aur_helper)
    
    if [ -z "$aur_helper" ]; then
        log_warning "No AUR helper found. Skipping AUR package: $package"
        return 1
    fi
    
    if is_package_installed "$package"; then
        log_info "AUR package already installed: $package"
        return 0
    fi
    
    log_step "Installing AUR package: $package"
    $aur_helper -S --noconfirm "$package"
    check_status "Failed to install AUR package: $package"
    
    log_success "Installed AUR package: $package"
}

# ============================================
# SYSTEM DETECTION
# ============================================

# Get current desktop environment
get_current_de() {
    echo "${XDG_CURRENT_DESKTOP:-unknown}"
}

# Get current display server
get_display_server() {
    if [ -n "$WAYLAND_DISPLAY" ]; then
        echo "wayland"
    elif [ -n "$DISPLAY" ]; then
        echo "x11"
    else
        echo "unknown"
    fi
}

# Get GPU vendor
get_gpu_vendor() {
    if lspci | grep -i vga | grep -qi nvidia; then
        echo "nvidia"
    elif lspci | grep -i vga | grep -qi amd; then
        echo "amd"
    elif lspci | grep -i vga | grep -qi intel; then
        echo "intel"
    else
        echo "unknown"
    fi
}

# ============================================
# SYSTEMD SERVICES
# ============================================

# Enable systemd service
enable_service() {
    local service="$1"
    local user_service="${2:-false}"
    
    if [ "$user_service" = "true" ]; then
        log_step "Enabling user service: $service"
        systemctl --user enable "$service"
        check_status "Failed to enable user service: $service"
    else
        log_step "Enabling system service: $service"
        sudo systemctl enable "$service"
        check_status "Failed to enable system service: $service"
    fi
    
    log_success "Enabled service: $service"
}

# Start systemd service
start_service() {
    local service="$1"
    local user_service="${2:-false}"
    
    if [ "$user_service" = "true" ]; then
        log_step "Starting user service: $service"
        systemctl --user start "$service"
        check_status "Failed to start user service: $service"
    else
        log_step "Starting system service: $service"
        sudo systemctl start "$service"
        check_status "Failed to start system service: $service"
    fi
    
    log_success "Started service: $service"
}

# ============================================
# REPOSITORY FUNCTIONS
# ============================================

# Get repository root directory
get_repo_root() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cd "$script_dir"
    
    # Go up until we find .git or reach home
    while [ "$PWD" != "$HOME" ] && [ "$PWD" != "/" ]; do
        if [ -d ".git" ] || [ -f "README.md" ]; then
            echo "$PWD"
            return 0
        fi
        cd ..
    done
    
    # Fallback: assume bobaland is in home
    echo "$HOME/bobaland"
}

# ============================================
# INITIALIZATION
# ============================================

# Initialize utilities (call this at the start of scripts)
init_utils() {
    init_logging
    check_not_root
    check_sudo
}

# ============================================
# EXPORT FUNCTIONS
# ============================================

# Make functions available to other scripts
export -f log_info log_success log_warning log_error log_step log_header
export -f die check_status command_exists
export -f ask_yes_no confirm_or_exit press_any_key
export -f backup_file create_symlink
export -f is_package_installed install_package install_packages
export -f has_aur_helper get_aur_helper install_aur_package
export -f enable_service start_service
export -f get_repo_root

# Script loaded successfully
log_info "Loaded bobaland utilities library"
