# Linux Mint Browser & Slack Installer

Automated installer for Google Chrome, Slack, and Opera on Linux Mint (and other Ubuntu-based distributions). The script must be run with root privileges and handles downloads, installation, logging, and progress display for you.

## Project Structure
```
.
├── install_apps.sh         # Main entry point
└── lib
    ├── colors.sh           # ANSI color definitions
    ├── helpers.sh          # Download & install helpers
    └── logging.sh          # Logging utilities
```

## Requirements

- Linux Mint (or similar Ubuntu-derived distro)
- Internet connection
- Root privileges (`sudo -i` or run script with `sudo`)

## Usage

1. Open a terminal.
2. Switch to root (recommended) or run via sudo:
   ```bash
   sudo ./install_apps.sh
   ```
   If you are already root (e.g., `sudo -i`), simply run `./install_apps.sh`.

## What the script does

1. Verifies it is running as root (exits otherwise).
2. Initializes logging to `logs/install_YYYYMMDD_HHMMSS.log`.
3. Ensures `~/Downloads` exists and uses it as the staging area.
4. Downloads the following installers with progress bars:
   - Google Chrome (`google-chrome-stable_current_amd64.deb`)
   - Slack (`slack-desktop-4.46.101-amd64.deb`)
   - Opera (`opera-stable_123.0.5669.23_amd64.deb`)
5. Installs each package via `dpkg -i`, auto-fixing dependencies with `apt-get install -f -y` when necessary.
6. Logs every step while also displaying colored status messages in the terminal.
7. Prints a centered **ALL DONE!** message when everything completes.

## Logs & Downloads

- Logs are created under `./logs/` alongside the installer script.
- Downloaded `.deb` files are stored in `~/Downloads`.

## Updating Versions

To update any application version, edit the URL and filename in the `urls` and `files` maps inside `install_apps.sh`.

## Troubleshooting

- Ensure you run the script with root privileges; otherwise it will exit immediately.
- If a package installation fails, check the corresponding log file for details.
- The script uses `apt-get install -f -y` to resolve missing dependencies automatically.
