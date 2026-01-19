#!/bin/bash

# VM Health Check Script for OKE
# This script monitors CPU, memory, and disk space usage
# Returns "healthy" if all parameters are below 70%, otherwise "unhealthy"

# Threshold for health check (in percentage)
THRESHOLD=70

# Function to get CPU usage percentage
get_cpu_usage() {
    # Using vmstat for more reliable cross-platform CPU usage
    # Get the idle CPU percentage and calculate usage
    local cpu_idle=$(vmstat 1 2 | tail -1 | awk '{print $15}')
    local cpu_usage=$((100 - cpu_idle))
    echo "$cpu_usage"
}

# Function to get memory usage percentage
get_memory_usage() {
    # Using free command to get memory usage based on available memory
    # This provides a more accurate picture of actual memory pressure
    local mem_usage=$(free | awk '/^Mem:/ {printf "%.0f", (($2-$7)/$2) * 100.0}')
    echo "$mem_usage"
}

# Function to get disk space usage percentage
get_disk_usage() {
    # Using df command to get disk usage of root partition
    local disk_usage=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
    echo "$disk_usage"
}

# Function to display current usage with explanation
explain_usage() {
    local cpu=$(get_cpu_usage)
    local memory=$(get_memory_usage)
    local disk=$(get_disk_usage)
    
    echo "=== VM Health Metrics ==="
    echo "CPU Usage:    ${cpu}%"
    echo "Memory Usage: ${memory}%"
    echo "Disk Usage:   ${disk}%"
    echo "========================="
    echo ""
    echo "Threshold: ${THRESHOLD}%"
    echo ""
    
    # Determine status for each metric
    if [ "$cpu" -gt "$THRESHOLD" ]; then
        echo "⚠️  CPU is above threshold (${cpu}% > ${THRESHOLD}%)"
    else
        echo "✅ CPU is healthy (${cpu}% <= ${THRESHOLD}%)"
    fi
    
    if [ "$memory" -gt "$THRESHOLD" ]; then
        echo "⚠️  Memory is above threshold (${memory}% > ${THRESHOLD}%)"
    else
        echo "✅ Memory is healthy (${memory}% <= ${THRESHOLD}%)"
    fi
    
    if [ "$disk" -gt "$THRESHOLD" ]; then
        echo "⚠️  Disk is above threshold (${disk}% > ${THRESHOLD}%)"
    else
        echo "✅ Disk is healthy (${disk}% <= ${THRESHOLD}%)"
    fi
}

# Function to perform health check
health_check() {
    local cpu=$(get_cpu_usage)
    local memory=$(get_memory_usage)
    local disk=$(get_disk_usage)
    
    # Validate that we got numeric values
    if ! [[ "$cpu" =~ ^[0-9]+$ ]] || ! [[ "$memory" =~ ^[0-9]+$ ]] || ! [[ "$disk" =~ ^[0-9]+$ ]]; then
        echo "Error: Unable to retrieve system metrics" >&2
        exit 2
    fi
    
    # Check if any parameter is above threshold
    if [ "$cpu" -gt "$THRESHOLD" ] || [ "$memory" -gt "$THRESHOLD" ] || [ "$disk" -gt "$THRESHOLD" ]; then
        echo "unhealthy"
        return 1
    else
        echo "healthy"
        return 0
    fi
}

# Main script logic
main() {
    if [ "$1" == "--explain" ] || [ "$1" == "-e" ]; then
        explain_usage
    elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "VM Health Check Script"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --explain, -e    Show detailed explanation of current resource usage"
        echo "  --help, -h       Show this help message"
        echo "  (no options)     Perform health check and return status"
        echo ""
        echo "Health Check:"
        echo "  Returns 'healthy' if CPU, Memory, and Disk usage are all below ${THRESHOLD}%"
        echo "  Returns 'unhealthy' if any metric is above ${THRESHOLD}%"
        echo ""
        echo "Exit Codes:"
        echo "  0 - System is healthy"
        echo "  1 - System is unhealthy"
        echo "  2 - Error retrieving system metrics"
    else
        health_check
    fi
}

# Execute main function
main "$@"
