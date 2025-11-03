# **Axxon Automation**  

▶ **Run:** `install_apps.sh` *(Chrome, Slack, Opera)*  
▶ **Build:** `build_deb.sh` *(produces axxon-automation_*.deb)*  
▶ **Install:** `sudo apt install ./dist/axxon-automation_*.deb`  
▶ **Logs:** `./logs/` or `/usr/lib/axxon-automation/logs/`  
▶ **Release:** Push to `main`; CI auto-tags v1.0.0, v1.0.1, …  
▶ **Launchpad:** `PACKAGE_VERSION=X.Y-Z ./scripts/build_deb.sh` then `dput ppa:letsconnectzohaib/axxon ../axxon-automation_*_source.changes`  
  - CI automation expects secrets: `LP_GPG_KEY` (armored key), `LP_GPG_PASSPHRASE`, `LP_USERNAME`  
*No sudo—run as root*
