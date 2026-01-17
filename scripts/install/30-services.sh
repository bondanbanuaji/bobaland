#!/usr/bin/env bash

# ============================================
# bobaland - Services Enablement Script
# ============================================
# Enables and starts required systemd services
# ============================================

set -e

# Script directory
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source utilities
source "$SCRIPT_DIR/utils.sh"

# ============================================
# SERVICE CONFIGURATION
# ============================================

# System services (require sudo)
readonly SYSTEM_SERVICES=(
    "NetworkManager"
    "bluetooth"
)

# User services (run as user)
readonly USER_SERVICES=(
    "pipewire"
    "pipewire-pulse"
    "wireplumber"
)

# ============================================
# ENABLE SYSTEM SERVICES
# ============================================

enable_system_services() {
    log_header "Enabling System Services"
    
    for service in "${SYSTEM_SERVICES[@]}"; do
        # Check if service exists
        if ! systemctl list-unit-files | grep -q "^${service}.service"; then
            log_warning "Service not found: $service (skipping)"
            continue
        fi
        
        # Check if already enabled
        if systemctl is-enabled "$service" &> /dev/null; then
            log_info "Already enabled: $service"
        else
            log_step "Enabling $service..."
            sudo systemctl enable "$service"
            check_status "Failed to enable $service"
            log_success "Enabled: $service"
        fi
        
        # Start service if not running
        if systemctl is-active "$service" &> /dev/null; then
            log_info "Already running: $service"
        else
            log_step "Starting $service..."
            sudo systemctl start "$service"
            check_status "Failed to start $service"
            log_success "Started: $service"
        fi
    done
    
    echo ""
}

# ============================================
# ENABLE USER SERVICES
# ============================================

enable_user_services() {
    log_header "Enabling User Services"
    
    for service in "${USER_SERVICES[@]}"; do
        # Check if service exists
        if ! systemctl --user list-unit-files | grep -q "^${service}.service"; then
            log_warning "User service not found: $service (skipping)"
            continue
        fi
        
        # Check if already enabled
        if systemctl --user is-enabled "$service" &> /dev/null; then
            log_info "Already enabled: $service"
        else
            log_step "Enabling user service: $service..."
            systemctl --user enable "$service"
            check_status "Failed to enable user service: $service"
            log_success "Enabled: $service"
        fi
        
        # Start service if not running (only if in a user session)
        if [ -n "$XDG_RUNTIME_DIR" ]; then
            if systemctl --user is-active "$service" &> /dev/null; then
                log_info "Already running: $service"
            else
                log_step "Starting user service: $service..."
                systemctl --user start "$service"
                check_status "Failed to start user service: $service"
                log_success "Started: $service"
            fi
        else
            log_info "Not in user session, $service will start on next login"
        fi
    done
    
    echo ""
}

# ============================================
# ADDITIONAL CONFIGURATION
# ============================================

configure_bluetooth() {
    log_step "Configuring Bluetooth..."
    
    # Enable bluetooth controller if rfkill is blocking it
    if command_exists rfkill; then
        if rfkill list bluetooth | grep -q "blocked: yes"; then
            log_info "Unblocking Bluetooth..."
            sudo rfkill unblock bluetooth
            log_success "Bluetooth unblocked"
        else
            log_info "Bluetooth not blocked"
        fi
    fi
}

configure_network() {
    log_step "Checking NetworkManager status..."
    
    # Disable dhcpcd if it's running (conflicts with NetworkManager)
    if systemctl is-active dhcpcd &> /dev/null; then
        log_warning "dhcpcd is running and may conflict with NetworkManager"
        if ask_yes_no "Disable dhcpcd?"; then
            sudo systemctl stop dhcpcd
            sudo systemctl disable dhcpcd
            log_success "dhcpcd disabled"
        fi
    fi
}

# ============================================
# VERIFICATION
# ============================================

verify_services() {
    log_header "Service Verification"
    
    local failed=0
    
    echo "System services:"
    for service in "${SYSTEM_SERVICES[@]}"; do
        if systemctl is-active "$service" &> /dev/null; then
            echo "  ✓ $service"
        else
            echo "  ✗ $service (not running)"
            ((failed++))
        fi
    done
    
    echo ""
    echo "User services:"
    for service in "${USER_SERVICES[@]}"; do
        if [ -n "$XDG_RUNTIME_DIR" ]; then
            if systemctl --user is-active "$service" &> /dev/null; then
                echo "  ✓ $service"
            else
                echo "  ✗ $service (not running)"
                ((failed++))
            fi
        else
            echo "  ? $service (will start on login)"
        fi
    done
    
    echo ""
    
    if [ $failed -eq 0 ]; then
        log_success "All services are running!"
    else
        log_warning "$failed service(s) not running"
        log_info "They may start after reboot or login"
    fi
}

# ============================================
# MAIN
# ============================================

main() {
    enable_system_services
    enable_user_services
    
    configure_bluetooth
    configure_network
    
    echo ""
    verify_services
    
    echo ""
    log_success "Service configuration completed!"
}

main "$@"
