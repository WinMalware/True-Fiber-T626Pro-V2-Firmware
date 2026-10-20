#!/bin/sh
# ==============================================================================
# T3 Technology T626ProV2 / PT632 — No-Flash Toolkit Installer
# Installs htop, nano, rsync, curl, ttyd, iperf3, tcpdump, etc. onto /custom_app
# ==============================================================================

echo "[*] Initializing T626ProV2 ModPack Installer..."

# Ensure /custom_app is writable
if ! mount | grep -q '/custom_app'; then
    echo "[*] Mounting /custom_app partition..."
    mount -t jffs2 /dev/mtdblock11 /custom_app 2>/dev/null || mkdir -p /custom_app
fi

mkdir -p /custom_app/bin /custom_app/etc /custom_app/share

# Extract toolkit archive
echo "[*] Unpacking toolkit binaries to /custom_app..."
tar -zxf custom_app_toolkit.tar.gz -C /custom_app/

# Add to profile & PATH
if ! grep -q '/custom_app/bin' /etc/profile 2>/dev/null; then
    echo 'export PATH=/custom_app/bin:$PATH' >> /etc/profile
    echo 'export TERMINFO=/custom_app/share/mini-terminfo' >> /etc/profile
fi

# Symlink core tools into standard path
for tool in htop nano rsync curl dig drill iperf3 tcpdump ethtool socat jq strace; do
    if [ -f "/custom_app/bin/$tool" ]; then
        ln -sf "/custom_app/bin/$tool" "/usr/bin/$tool" 2>/dev/null || true
    fi
done

# Start Web Terminal in background on port 7681
if [ -x /custom_app/bin/ttyd ] && ! ps | grep -v grep | grep -q "ttyd"; then
    echo "[*] Starting Web Terminal on port 7681 (superadmin:lament)..."
    setsid /custom_app/bin/ttyd -W -p 7681 -c superadmin:lament /bin/sh >/dev/null 2>&1 &
fi

sync
echo "[✓] Installation complete! Test with: htop, nano, rsync, curl, ttyd"
