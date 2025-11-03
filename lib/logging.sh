#!/bin/bash

LOG_DIR=""
LOG_FILE=""
LOG_READY=false

init_logging() {
    local base_dir="$1"
    LOG_DIR="$base_dir/logs"
    mkdir -p "$LOG_DIR"
    local timestamp="$(date +"%Y%m%d_%H%M%S")"
    LOG_FILE="$LOG_DIR/install_${timestamp}.log"
    : > "$LOG_FILE"
    LOG_READY=true
}

log_message() {
    local level="$1"
    local message="$2"
    if [[ $LOG_READY == true ]]; then
        local timestamp
        timestamp="$(date +"%Y-%m-%d %H:%M:%S")"
        echo "$timestamp [$level] $message" >> "$LOG_FILE"
    fi
}

log_and_print() {
    local level="$1"
    local color="$2"
    local message="$3"

    log_message "$level" "$message"
    echo -e "${color}[$level]${NC} $message"
}

run_with_log() {
    if [[ $LOG_READY == true ]]; then
        "$@" 2>&1 | tee -a "$LOG_FILE"
    else
        "$@"
    fi
}

log_summary_line() {
    local message="$1"
    if [[ $LOG_READY == true ]]; then
        echo "$message" >> "$LOG_FILE"
    fi
}
