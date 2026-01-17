#!/usr/bin/env bash

# ============================================
# bobaland - Screenshot Utility
# ============================================
# Enhanced screenshot tool using grim and slurp
# ============================================

set -e

# Configuration
readonly SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
readonly TIMESTAMP_FORMAT="%Y%m%d_%H%M%S"

# Colors
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_RESET='\033[0m'

# ============================================
# FUNCTIONS
# ============================================

# Ensure screenshot directory exists
init_screenshot_dir() {
    mkdir -p "$SCREENSHOT_DIR"
}

# Take fullscreen screenshot
screenshot_full() {
    local filename="$SCREENSHOT_DIR/screenshot_$(date +$TIMESTAMP_FORMAT).png"
    
    grim "$filename"
    
    if [ $? -eq 0 ]; then
        echo -e "${COLOR_GREEN}✓${COLOR_RESET} Screenshot saved: $filename"
        notify-send "Screenshot" "Fullscreen saved" -i "$filename"
        
        # Copy to clipboard
        wl-copy < "$filename"
    else
        echo -e "${COLOR_RED}✗${COLOR_RESET} Failed to capture screenshot"
        notify-send "Screenshot" "Failed to capture" -u critical
        return 1
    fi
}

# Take area screenshot
screenshot_area() {
    local filename="$SCREENSHOT_DIR/screenshot_$(date +$TIMESTAMP_FORMAT).png"
    
    local geometry=$(slurp)
    
    if [ -z "$geometry" ]; then
        echo "Selection cancelled"
        return 0
    fi
    
    grim -g "$geometry" "$filename"
    
    if [ $? -eq 0 ]; then
        echo -e "${COLOR_GREEN}✓${COLOR_RESET} Screenshot saved: $filename"
        notify-send "Screenshot" "Area saved" -i "$filename"
        
        # Copy to clipboard
        wl-copy < "$filename"
    else
        echo -e "${COLOR_RED}✗${COLOR_RESET} Failed to capture screenshot"
        notify-send "Screenshot" "Failed to capture" -u critical
        return 1
    fi
}

# Take active window screenshot
screenshot_window() {
    local filename="$SCREENSHOT_DIR/screenshot_$(date +$TIMESTAMP_FORMAT).png"
    
    # Get active window geometry using hyprctl
    local geometry=$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
    
    if [ -z "$geometry" ] || [ "$geometry" = "null" ]; then
        echo -e "${COLOR_RED}✗${COLOR_RESET} No active window"
        notify-send "Screenshot" "No active window" -u critical
        return 1
    fi
    
    grim -g "$geometry" "$filename"
    
    if [ $? -eq 0 ]; then
        echo -e "${COLOR_GREEN}✓${COLOR_RESET} Screenshot saved: $filename"
        notify-send "Screenshot" "Window saved" -i "$filename"
        
        # Copy to clipboard
        wl-copy < "$filename"
    else
        echo -e "${COLOR_RED}✗${COLOR_RESET} Failed to capture screenshot"
        notify-send "Screenshot" "Failed to capture" -u critical
        return 1
    fi
}

# Take screenshot and edit with swappy
screenshot_edit() {
    local geometry=$(slurp)
    
    if [ -z "$geometry" ]; then
        echo "Selection cancelled"
        return 0
    fi
    
    grim -g "$geometry" - | swappy -f -
}

# Show help
show_help() {
    cat << EOF
bobaland Screenshot Utility

Usage: $(basename "$0") [MODE]

MODES:
    full    - Fullscreen screenshot (default)
    area    - Select area screenshot
    window  - Active window screenshot
    edit    - Select area and edit with swappy
    -h      - Show this help

Screenshots are saved to: $SCREENSHOT_DIR
Screenshots are automatically copied to clipboard.

EOF
}

# ============================================
# MAIN
# ============================================

main() {
    # Initialize
    init_screenshot_dir
    
    # Parse mode
    local mode="${1:-full}"
    
    case "$mode" in
        full|fullscreen)
            screenshot_full
            ;;
        area|region|select)
            screenshot_area
            ;;
        window|active)
            screenshot_window
            ;;
        edit|swappy)
            screenshot_edit
            ;;
        -h|--help|help)
            show_help
            ;;
        *)
            echo "Unknown mode: $mode"
            echo "Use -h for help"
            exit 1
            ;;
    esac
}

main "$@"
