#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )/.." && pwd)"
VERSION="$(cat "$ROOT_DIR/VERSION")"
PKG_NAME="axxon-automation"
ARCH="amd64"
BUILD_DIR="$ROOT_DIR/build"
PKG_DIR="$BUILD_DIR/$PKG_NAME"
PKG_ROOT="$PKG_DIR/usr/lib/$PKG_NAME"
BIN_DIR="$PKG_DIR/usr/bin"
DEBIAN_DIR="$PKG_DIR/DEBIAN"
DIST_DIR="$ROOT_DIR/dist"
OUTPUT_DEB="$DIST_DIR/${PKG_NAME}_${VERSION}_${ARCH}.deb"

rm -rf "$BUILD_DIR" "$DIST_DIR"
mkdir -p "$PKG_ROOT" "$BIN_DIR" "$DEBIAN_DIR" "$DIST_DIR" "$PKG_ROOT/logs"

install -m 0755 "$ROOT_DIR/install_apps.sh" "$PKG_ROOT/install_apps.sh"
install -m 0755 -d "$PKG_ROOT/lib"
install -m 0644 "$ROOT_DIR/lib/colors.sh" "$PKG_ROOT/lib/colors.sh"
install -m 0644 "$ROOT_DIR/lib/logging.sh" "$PKG_ROOT/lib/logging.sh"
install -m 0644 "$ROOT_DIR/lib/helpers.sh" "$PKG_ROOT/lib/helpers.sh"

cat > "$BIN_DIR/axxon-automation" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
exec /usr/lib/axxon-automation/install_apps.sh "$@"
EOF
chmod 0755 "$BIN_DIR/axxon-automation"

cat > "$DEBIAN_DIR/control" <<EOF
Package: ${PKG_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Depends: bash, wget, curl, dpkg, apt
Maintainer: Axxon Automation <support@example.com>
Description: Automated installer for Chrome, Slack and Opera
 A helper utility that downloads and installs Google Chrome,
 Slack, and Opera with logging and progress indicators.
EOF

cat > "$DEBIAN_DIR/postinst" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
/usr/bin/axxon-automation || true
exit 0
EOF
chmod 0755 "$DEBIAN_DIR/postinst"

dpkg-deb --build "$PKG_DIR" "$OUTPUT_DEB"

echo "Created package: $OUTPUT_DEB"
