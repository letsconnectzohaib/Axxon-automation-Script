#!/bin/sh
# Build script for axxon-automation Debian packages.
# Requires PACKAGE_VERSION (format X.Y-Z) in environment.
# Generates both binary and source packages using debuild.
set -eu

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
VERSION=${PACKAGE_VERSION:-}

if [ -z "$VERSION" ]; then
    echo "PACKAGE_VERSION not set" >&2
    exit 1
fi

export DEBFULLNAME="${DEBFULLNAME:-Mr. Zohaib}"
export DEBEMAIL="${DEBEMAIL:-letsconnectzohaib@gmail.com}"

cd "$ROOT_DIR"

CURRENT_VERSION=$(dpkg-parsechangelog --show-field Version 2>/dev/null || echo "")
if [ "$CURRENT_VERSION" != "$VERSION" ]; then
    dch --newversion "$VERSION" \
        --distribution unstable \
        "Automated release for $VERSION."
fi

rm -rf dist
mkdir -p dist

debuild -b -uc -us
debuild -S -sa -uc -us

PKG_DEB="../axxon-automation_${VERSION}_all.deb"
if [ -f "$PKG_DEB" ]; then
    cp "$PKG_DEB" dist/
fi

echo "Binary packages copied to dist/. Source changes in parent directory."
