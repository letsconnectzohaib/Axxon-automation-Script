#!/bin/bash

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
DOWNLOAD_DIR="$HOME/Downloads"

require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This installer must be run with sudo or as the root user."
        exit 1
    fi
}

prepare_environment() {
    mkdir -p "$DOWNLOAD_DIR"
}

progress_download() {
    local url="$1"
    local output="$2"

    if [[ $LOG_READY == true ]]; then
        wget --progress=bar:force:noscroll -O "$output" "$url" 2>&1 | tee -a "$LOG_FILE"
    else
        wget --progress=bar:force:noscroll -O "$output" "$url"
    fi
}

install_deb_package() {
    local package_path="$1"
    local package_name="$2"

    local dpkg_status=0
    DEBIAN_FRONTEND=noninteractive run_with_log dpkg -i "$package_path" || dpkg_status=$?

    if [[ $dpkg_status -ne 0 ]]; then
        log_and_print "WARNING" "$YELLOW" "dpkg reported issues while installing $package_name. Attempting to fix dependencies..."
    fi

    DEBIAN_FRONTEND=noninteractive run_with_log apt-get install -f -y

    if [[ $dpkg_status -ne 0 ]]; then
        DEBIAN_FRONTEND=noninteractive run_with_log dpkg -i "$package_path"
    fi
}
