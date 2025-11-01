#!/bin/bash

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd)"
DOWNLOAD_DIR="$HOME/Downloads"

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

    DEBIAN_FRONTEND=noninteractive run_with_log dpkg -i "$package_path"
    run_with_log apt-get install -f -y
}
