# Axxon Installer

One-command installer for Linux Mint:
```bash
git clone <repo-url> && cd Axxon-Download-Script && sudo ./install_apps.sh
```

### What it does
- Installs Chrome, Slack, Opera
- Auto-fixes dependencies
- Logs to `./logs/`

### Debian Package
```bash
./scripts/build_deb.sh && sudo apt install ./dist/*.deb
```

### Update URLs
Edit `urls` map in `install_apps.sh`.

### Logs
Check `./logs/install_*.log` for details.
