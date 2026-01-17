#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/log.sh"

log_info "Setting up Hyprland environment..."

# Example: Copying/Symlinking config files if not using Stow
# This is a fallback if strict Stow usage isn't desired
CONFIG_SRC="$SCRIPT_DIR/config"
CONFIG_DEST="$HOME/.config"

link_config() {
    local component=$1
    if [[ -d "$CONFIG_SRC/$component" ]]; then
        log_info "Linking $component config..."
        if [[ "$DRY_RUN" == "true" ]]; then
             log_warn "[DRY-RUN] Would link $CONFIG_SRC/$component to $CONFIG_DEST/$component"
        else
            mkdir -p "$CONFIG_DEST"
            if [ -e "$CONFIG_DEST/$component" ]; then
                if [ "$BACKUP" == "true" ]; then
                    mv "$CONFIG_DEST/$component" "$CONFIG_DEST/${component}.bak.$(date +%s)"
                    log_info "Backed up existing $component config."
                else
                    rm -rf "$CONFIG_DEST/$component"
                    log_warn "Removed existing $component config (no backup)."
                fi
            fi
            ln -sf "$CONFIG_SRC/$component" "$CONFIG_DEST/$component"
        fi
    fi
}

# Link key components
link_config "hypr"
link_config "waybar"
link_config "wlogout"
link_config "dunst"
link_config "kitty"
link_config "wofi"

log_success "Hyprland configuration setup complete."
