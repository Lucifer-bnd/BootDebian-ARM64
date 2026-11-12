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

if [ ! -f "$ARCHIVE" ]; then
    abort "Debian RootFS archive is missing!"
fi

if [ -x "$ROOTFS/bin/bash" ]; then
    ui_print "Existing Debian installation detected."
    ui_print "Keeping existing Debian data."
else
    if [ -d "$ROOTFS" ]; then
        abort "Incomplete Debian directory exists. Please inspect /data/local/debian first."
    fi

    ui_print "Extracting Debian 13 ARM64..."
    mkdir -p "$ROOTFS" || abort "Cannot create Debian directory."

    tar -xzf "$ARCHIVE" -C "$ROOTFS" \
        || abort "Debian extraction failed!"

    chmod 755 "$ROOTFS"
fi

mkdir -p "$ROOTFS/dev" "$ROOTFS/proc" "$ROOTFS/sys" \
    "$ROOTFS/dev/pts" "$ROOTFS/tmp"

chmod 1777 "$ROOTFS/tmp"

chmod 755 "$MODPATH/system/bin/bootdebian"

ui_print " "
ui_print "Debian installation completed!"
ui_print "Reboot your device if necessary."
ui_print "Run bootdebian from a root terminal."
ui_print " "

