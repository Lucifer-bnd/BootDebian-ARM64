#!/system/bin/sh

# Remove only the standalone launcher.
# Keep /data/local/debian so user data survives module removal.

rm -f /data/adb/bootdebian

ui_print "BootDebian launcher removed."
ui_print "Debian data was preserved at /data/local/debian."
ui_print "Delete that directory manually only if you also want to erase Debian."
