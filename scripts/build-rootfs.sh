#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ROOTFS="$PROJECT_DIR/work/rootfs"
MODULE="$PROJECT_DIR/module"

echo "=================================="
echo " BootDebian ARM64 RootFS Builder"
echo " Debian 13 Trixie"
echo "=================================="

sudo apt-get update

sudo apt-get install -y \
    debootstrap \
    qemu-user-static \
    binfmt-support \
    ca-certificates \
    tar \
    gzip

sudo update-binfmts --enable qemu-aarch64 || true

sudo rm -rf "$ROOTFS"
mkdir -p "$ROOTFS"

echo "[1/5] Creating ARM64 Debian base..."

sudo debootstrap \
    --arch=arm64 \
    --foreign \
    --variant=minbase \
    trixie \
    "$ROOTFS" \
    https://deb.debian.org/debian/

echo "[2/5] Preparing QEMU..."

sudo install -D \
    /usr/bin/qemu-aarch64-static \
    "$ROOTFS/usr/bin/qemu-aarch64-static"

echo "[3/5] Running Debian second stage..."

sudo chroot "$ROOTFS" \
    /debootstrap/debootstrap --second-stage

echo "[4/5] Configuring Debian..."

sudo cp "$PROJECT_DIR/scripts/configure-debian.sh" \
    "$ROOTFS/tmp/configure-debian.sh"

sudo cp "$PROJECT_DIR/config/packages.txt" \
    "$ROOTFS/tmp/packages.txt"

sudo chmod +x "$ROOTFS/tmp/configure-debian.sh"

sudo chroot "$ROOTFS" \
    /bin/bash /tmp/configure-debian.sh

echo "[5/5] Cleaning and packaging..."

sudo rm -f "$ROOTFS/usr/bin/qemu-aarch64-static"
sudo rm -f "$ROOTFS/tmp/configure-debian.sh"
sudo rm -f "$ROOTFS/tmp/packages.txt"

sudo mkdir -p "$MODULE"

sudo tar \
    --numeric-owner \
    --exclude='./dev/*' \
    --exclude='./proc/*' \
    --exclude='./sys/*' \
    -czf "$MODULE/debian-rootfs.tar.gz" \
    -C "$ROOTFS" .

echo "=================================="
echo " RootFS build completed!"
echo "=================================="
ls -lh "$MODULE/debian-rootfs.tar.gz"

