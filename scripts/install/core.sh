#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
source "$SCRIPT_DIR/scripts/utils/log.sh"

PACKAGES_FILE="$SCRIPT_DIR/packages/official.txt"

log_info "Updating system..."
if [[ "$DRY_RUN" == "true" ]]; then
    log_warn "[DRY-RUN] Would run: sudo pacman -Syu --noconfirm"
else
    sudo pacman -Syu --noconfirm
fi

log_info "Installing official packages..."
if [[ ! -f "$PACKAGES_FILE" ]]; then
    log_error "Packages file not found: $PACKAGES_FILE"
    exit 1
fi

packages=$(grep -vE "^\s*#" "$PACKAGES_FILE" | tr '\n' ' ')

if [[ "$DRY_RUN" == "true" ]]; then
    log_warn "[DRY-RUN] Would install: $packages"
else
    # Install packages, handle potential failures gracefully or ensure sudo
    sudo pacman -S --needed --noconfirm $packages
fi

log_success "Core packages installed."
