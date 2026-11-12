#!/system/bin/sh

ui_print " "
ui_print "*******************************"
ui_print "       BootDebian ARM64"
ui_print "       Debian 13 Trixie"
ui_print "*******************************"

DEVICE_ARCH="$(uname -m)"
if [ "$DEVICE_ARCH" != "aarch64" ]; then
    abort "BootDebian requires ARM64 / AArch64."
fi

ROOTFS="/data/local/debian"
ARCHIVE="$MODPATH/debian-rootfs.tar.gz"
LAUNCHER_SOURCE="$MODPATH/bootdebian"
LAUNCHER_TARGET="/data/adb/bootdebian"

if [ ! -f "$ARCHIVE" ]; then
    abort "Debian RootFS archive is missing!"
fi

if [ ! -f "$LAUNCHER_SOURCE" ]; then
    abort "BootDebian launcher is missing from the module ZIP!"
fi

if [ -x "$ROOTFS/bin/bash" ]; then
    ui_print "Existing Debian installation detected."
    ui_print "Keeping existing Debian data."
else
    if [ -e "$ROOTFS" ]; then
        abort "An incomplete Debian directory exists. Inspect /data/local/debian before continuing."
    fi

    ui_print "Extracting Debian 13 ARM64..."
    mkdir -p "$ROOTFS" || abort "Cannot create Debian directory."
    tar -xzf "$ARCHIVE" -C "$ROOTFS" || abort "Debian extraction failed!"
    chmod 755 "$ROOTFS"
fi

mkdir -p "$ROOTFS/dev/pts" "$ROOTFS/proc" "$ROOTFS/sys" "$ROOTFS/tmp"
chmod 1777 "$ROOTFS/tmp"

ui_print "Installing standalone launcher..."
mkdir -p /data/adb || abort "Cannot access /data/adb."
cp "$LAUNCHER_SOURCE" "$LAUNCHER_TARGET" || abort "Could not install bootdebian launcher."
chmod 0755 "$LAUNCHER_TARGET" || abort "Could not set launcher permissions."

ui_print " "
ui_print "BootDebian installation completed!"
ui_print "Start a root terminal and run: /data/adb/bootdebian"
ui_print "Debian data is stored in /data/local/debian."
ui_print " "
