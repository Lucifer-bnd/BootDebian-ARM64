#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MODULE="$PROJECT_DIR/module"
OUTPUT="$PROJECT_DIR/bootdebian-arm64.zip"

if [ ! -f "$MODULE/debian-rootfs.tar.gz" ]; then
    echo "ERROR: Debian RootFS archive not found!"
    exit 1
fi

echo "[BootDebian] Packaging module..."

rm -f "$OUTPUT"

cd "$MODULE"

zip -r -0 "$OUTPUT" .

unzip -t "$OUTPUT"

echo " "
echo "Build package completed!"
echo "Output: $OUTPUT"

sha256sum "$OUTPUT"
ls -lh "$OUTPUT"

