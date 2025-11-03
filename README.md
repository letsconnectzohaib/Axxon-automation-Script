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

## Debian Package & Releases

- The current version is stored in the top-level `VERSION` file.
- Run `./scripts/build_deb.sh` to produce `dist/axxondl-installer_<version>_amd64.deb`.
- Installing the package places the runtime under `/usr/lib/axxondl-installer/` and exposes the command `axxondl-installer`.
- After installation the post-install hook immediately launches the installer flow so the apps are provisioned right away.
- GitHub Actions workflow `.github/workflows/release.yml` builds the package and publishes it as a GitHub Release asset whenever `main` is updated.

## Updating Versions

To update any application version, edit the URL and filename in the `urls` and `files` maps inside `install_apps.sh`.

When releasing a new Debian package:
1. Update the `VERSION` file (e.g., `1.1.0`).
2. Commit the changes and push to `main`.
3. The workflow will tag `v<version>` and upload the generated `.deb` to the release page.

## Troubleshooting

- Ensure you run the script with root privileges; otherwise it will exit immediately.
- If a package installation fails, check the corresponding log file for details.
- The script uses `apt-get install -f -y` to resolve missing dependencies automatically.

---

## ❗ Troubleshooting

### Common Issues

- **Permission denied**: Run with `sudo` or as root.
- **Download failures**: Check internet connection and update URLs in `install_apps.sh`.
- **Installation errors**: Run `sudo apt-get install -f` to fix dependencies manually.

### Logs

Detailed logs are written to:
- Standalone mode: `./logs/install_<timestamp>.log`
- Debian package: `/usr/lib/axxondl-installer/logs/install_<timestamp>.log`

---

## 🚀 Getting Help

For support, open an issue with:
- The log file from the failed run
- Your Linux distribution version (`lsb_release -a`)
- Any error messages shown in the terminal

---

## 📜 License

MIT Licensed. See [LICENSE](LICENSE) for details.
