#!/usr/bin/env bash

# ============================================
# bobaland - Wallpaper Switcher
# ============================================
# Interactive wallpaper selector using swww
# ============================================

set -e

# Configuration
readonly WALLPAPER_DIR="$HOME/bobaland/wallpapers"
readonly CURRENT_WALLPAPER_FILE="$HOME/.cache/current_wallpaper"

# Colors
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_RESET='\033[0m'

# ============================================
# FUNCTIONS
# ============================================

# Initialize swww if not running
init_swww() {
    if ! pgrep -x swww-daemon > /dev/null; then
        echo -e "${COLOR_BLUE}→${COLOR_RESET} Starting swww daemon..."
        swww init
        sleep 1
    fi
}

# Get list of wallpapers
get_wallpapers() {
    find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null
}

# Set wallpaper
set_wallpaper() {
    local wallpaper="$1"
    
    if [ ! -f "$wallpaper" ]; then
        echo "Error: Wallpaper not found: $wallpaper"
        return 1
    fi
    
    echo -e "${COLOR_BLUE}→${COLOR_RESET} Setting wallpaper..."
    
    swww img "$wallpaper" \
        --transition-type wipe \
        --transition-duration 1.5
    
    if [ $? -eq 0 ]; then
        echo "$wallpaper" > "$CURRENT_WALLPAPER_FILE"
        echo -e "${COLOR_GREEN}✓${COLOR_RESET} Wallpaper set: $(basename "$wallpaper")"
        notify-send "Wallpaper Changed" "$(basename "$wallpaper")" -i "$wallpaper"
    else
        echo "Error: Failed to set wallpaper"
        return 1
    fi
}

# Select wallpaper with rofi
select_wallpaper_rofi() {
    local wallpapers=($(get_wallpapers))
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        notify-send "Wallpaper Switcher" "No wallpapers found" -u critical
        return 1
    fi
    
    # Create menu entries with basenames
    local menu_entries=()
    for wallpaper in "${wallpapers[@]}"; do
        menu_entries+=("$(basename "$wallpaper")")
    done
    
    # Show rofi menu
    local selection=$(printf '%s\n' "${menu_entries[@]}" | rofi -dmenu -i -p "Select Wallpaper")
    
    if [ -z "$selection" ]; then
        echo "Cancelled"
        return 0
    fi
    
    # Find full path of selected wallpaper
    for wallpaper in "${wallpapers[@]}"; do
        if [ "$(basename "$wallpaper")" = "$selection" ]; then
            set_wallpaper "$wallpaper"
            return $?
        fi
    done
}

# Random wallpaper
random_wallpaper() {
    local wallpapers=($(get_wallpapers))
    
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        return 1
    fi
    
    local random_index=$((RANDOM % ${#wallpapers[@]}))
    local selected="${wallpapers[$random_index]}"
    
    set_wallpaper "$selected"
}

# Show current wallpaper
show_current() {
    if [ -f "$CURRENT_WALLPAPER_FILE" ]; then
        local current=$(cat "$CURRENT_WALLPAPER_FILE")
        echo "Current wallpaper: $(basename "$current")"
        echo "Path: $current"
    else
        echo "No current wallpaper recorded"
    fi
}

# Show help
show_help() {
    cat << EOF
bobaland Wallpaper Switcher

Usage: $(basename "$0") [MODE] [PATH]

MODES:
    select  - Interactive selection with rofi (default)
    random  - Set random wallpaper
    set     - Set specific wallpaper (requires PATH)
    current - Show current wallpaper
    -h      - Show this help

EXAMPLES:
    $(basename "$0")                    # Interactive selection
    $(basename "$0") random             # Random wallpaper
    $(basename "$0") set ~/pics/bg.jpg  # Set specific wallpaper

Wallpapers directory: $WALLPAPER_DIR

EOF
}

# ============================================
# MAIN
# ============================================

main() {
    # Check if wallpaper directory exists
    if [ ! -d "$WALLPAPER_DIR" ]; then
        echo "Wallpaper directory not found: $WALLPAPER_DIR"
        mkdir -p "$WALLPAPER_DIR"
        echo "Created wallpaper directory. Add wallpapers to: $WALLPAPER_DIR"
        exit 1
    fi
    
    # Initialize swww
    init_swww
    
    # Parse mode
    local mode="${1:-select}"
    
    case "$mode" in
        select|menu)
            select_wallpaper_rofi
            ;;
        random|rand)
            random_wallpaper
            ;;
        set)
            if [ -z "$2" ]; then
                echo "Error: Path required for 'set' mode"
                echo "Usage: $0 set /path/to/wallpaper.jpg"
                exit 1
            fi
            set_wallpaper "$2"
            ;;
        current|show)
            show_current
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
