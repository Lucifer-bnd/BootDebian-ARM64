#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

echo "[BootDebian] Configuring Debian 13..."

cat > /etc/apt/sources.list <<'EOF'
deb https://deb.debian.org/debian trixie main contrib non-free non-free-firmware
deb https://deb.debian.org/debian trixie-updates main contrib non-free non-free-firmware
deb https://security.debian.org/debian-security trixie-security main contrib non-free non-free-firmware
EOF

apt-get update

xargs -r apt-get install -y --no-install-recommends < /tmp/packages.txt

echo "bootdebian" > /etc/hostname

if [ -f /etc/locale.gen ]; then
    sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    locale-gen
fi

update-locale LANG=en_US.UTF-8

mkdir -p /root

cat > /etc/resolv.conf <<'EOF'
nameserver 1.1.1.1
nameserver 8.8.8.8
EOF

apt-get clean
rm -rf /var/lib/apt/lists/*

echo "[BootDebian] Configuration completed."

