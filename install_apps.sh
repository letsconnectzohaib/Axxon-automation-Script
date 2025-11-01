#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/logging.sh"
source "$SCRIPT_DIR/lib/helpers.sh"

info() {
    log_and_print "INFO" "$GREEN" "$1"
}

warn() {
    log_and_print "WARNING" "$YELLOW" "$1"
}

error_msg() {
    log_and_print "ERROR" "$RED" "$1"
}

center_message() {
    local message="$1"
    local cols
    cols=$(tput cols 2>/dev/null || echo 80)
    local padding=$(( (cols - ${#message}) / 2 ))
    if (( padding > 0 )); then
        printf "%*s%s\n" "$padding" "" "$message"
    else
        echo "$message"
    fi
}

download_and_install() {
    local name="$1"
    local url="$2"
    local filename="$3"
    local destination="$DOWNLOAD_DIR/$filename"

    info "Downloading $name..."
    progress_download "$url" "$destination"

    info "Installing $name..."
    install_deb_package "$destination" "$name"

    info "$name installed successfully."
}

main() {
    require_root
    init_logging "$SCRIPT_DIR"

    info "Starting installer for Chrome, Slack, and Opera..."

    prepare_environment

    declare -A urls=(
        [Google_Chrome]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
        [Slack]="https://downloads.slack-edge.com/desktop-releases/linux/x64/4.46.101/slack-desktop-4.46.101-amd64.deb"
        [Opera]="https://download5.operacdn.com/ftp/pub/opera/desktop/123.0.5669.23/linux/opera-stable_123.0.5669.23_amd64.deb"
    )

    declare -A files=(
        [Google_Chrome]="google-chrome-stable_current_amd64.deb"
        [Slack]="slack-desktop-4.46.101-amd64.deb"
        [Opera]="opera-stable_123.0.5669.23_amd64.deb"
    )

    info "All downloads will be stored in $DOWNLOAD_DIR"

    download_and_install "Google Chrome" "${urls[Google_Chrome]}" "${files[Google_Chrome]}"
    download_and_install "Slack" "${urls[Slack]}" "${files[Slack]}"
    download_and_install "Opera" "${urls[Opera]}" "${files[Opera]}"

    info "Installation steps completed."
    local done_message="ALL DONE!"
    printf "\n"
    center_message "${GREEN}${done_message}${NC}"
    printf "\n"
    log_summary_line "All applications installed successfully."
}

main "$@"
