#!/usr/bin/env bash

# ============================================
# bobaland - Symlink Creation Script
# ============================================
# Creates symbolic links for configuration files
# ============================================

set -e

# Script directory
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# ============================================
# CONFIGURATION SYMLINKS
# ============================================

create_config_symlinks() {
    log_step "Creating symlinks for .config files..."
    
    local config_dirs=(
        "hypr"
        "waybar"
        "kitty"
        "rofi"
        "dunst"
        "wlogout"
        "nvim"
        "alacritty"
    )
    
    local created=0
    local skipped=0
    
    for dir in "${config_dirs[@]}"; do
        local source="$REPO_ROOT/.config/$dir"
        local target="$HOME/.config/$dir"
        
        # Check if source exists
        if [ ! -e "$source" ]; then
            log_info "Skipping $dir (not found in repository)"
            ((skipped++))
            continue
        fi
        
        # Create symlink
        create_symlink "$source" "$target"
        ((created++))
    done
    
    log_success "Created $created symlinks ($skipped skipped)"
}

# ============================================
# WALLPAPER SYMLINKS
# ============================================

create_wallpaper_symlinks() {
    log_step "Setting up wallpapers..."
    
    local wallpaper_source="$REPO_ROOT/wallpapers"
    local wallpaper_target="$HOME/.local/share/wallpapers/bobaland"
    
    if [ ! -d "$wallpaper_source" ]; then
        log_warning "Wallpaper directory not found, skipping..."
        return 0
    fi
    
    # Create target directory
    mkdir -p "$(dirname "$wallpaper_target")"
    
    # Create symlink
    create_symlink "$wallpaper_source" "$wallpaper_target"
    
    log_success "Wallpapers linked"
}

# ============================================
# SCRIPT SYMLINKS
# ============================================

setup_scripts() {
    log_step "Setting up utility scripts..."
    
    local script_dirs=(
        "utils"
        "system"
    )
    
    local bin_dir="$HOME/.local/bin"
    mkdir -p "$bin_dir"
    
    # Make scripts executable
    chmod +x "$REPO_ROOT/scripts/utils/"* 2>/dev/null || true
    chmod +x "$REPO_ROOT/scripts/system/"* 2>/dev/null || true
    
    # Add common scripts to PATH
    local util_scripts=(
        "wallpaper-switcher.sh:bobaland-wallpaper"
        "screenshot.sh:bobaland-screenshot"
        "colorpicker.sh:bobaland-colorpicker"
        "theme-switcher.sh:bobaland-theme"
    )
    
    local linked=0
    
    for entry in "${util_scripts[@]}"; do
        IFS=: read -r script_name link_name <<< "$entry"
        local source="$REPO_ROOT/scripts/utils/$script_name"
        local target="$bin_dir/$link_name"
        
        if [ ! -f "$source" ]; then
            continue
        fi
        
        create_symlink "$source" "$target"
        ((linked++))
    done
    
    log_success "Linked $linked utility scripts to ~/.local/bin/"
    
    # Check if ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        log_warning "~/.local/bin is not in your PATH"
        log_info "Add this to your shell config (~/.bashrc or ~/.zshrc):"
echo '  export PATH="$HOME/.local/bin:$PATH"'
    fi
}

# ============================================
# VERIFICATION
# ============================================

verify_symlinks() {
    log_step "Verifying symlinks..."
    
    local broken=0
    local valid=0
    
    # Check critical symlinks
    local critical_links=(
        "$HOME/.config/hypr"
        "$HOME/.config/waybar"
        "$HOME/.config/kitty"
    )
    
    for link in "${critical_links[@]}"; do
        if [ -L "$link" ]; then
            if [ -e "$link" ]; then
                ((valid++))
            else
                log_warning "Broken symlink: $link"
                ((broken++))
            fi
        else
            if [ -e "$link" ]; then
                log_warning "Not a symlink (directory exists): $link"
            else
                log_warning "Missing: $link"
                ((broken++))
            fi
        fi
    done
    
    if [ $broken -eq 0 ]; then
        log_success "All critical symlinks are valid"
    else
        log_warning "$broken symlink issues found"
    fi
}

# ============================================
# MAIN
# ============================================

main() {
    log_header "Creating Symbolic Links"
    
    # Create configuration symlinks
    create_config_symlinks
    
    echo ""
    
    # Setup wallpapers
    create_wallpaper_symlinks
    
    echo ""
    
    # Setup utility scripts
    setup_scripts
    
    echo ""
    
    # Verify
    verify_symlinks
    
    echo ""
    log_success "Symlink creation completed successfully!"
}

main "$@"
