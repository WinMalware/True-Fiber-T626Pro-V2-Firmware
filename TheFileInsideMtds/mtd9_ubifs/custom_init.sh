#!/bin/sh
# ========================================================
# Permanent Dropbear SSH, SCP, OverlayFS & Boot Hook
# ========================================================

sleep 3

# 0. Neutralize EasyMesh BSS Stop Daemon
if [ -f /usr/ubifs/bin/wapp ]; then
    mount -o bind /usr/ubifs/bin/wapp /userfs/bin/wapp 2>/dev/null
fi

# 1. Mount OverlayFS across all non-virtual directories
[ -x /usr/ubifs/bin/remount_rw ] && /usr/ubifs/bin/remount_rw >/dev/null 2>&1

# 2. Prepare Environment & Fix SCP / SSH PATH
mkdir -p /var/run /etc/dropbear /usr/ubifs/etc/dropbear
[ -f /usr/ubifs/etc/motd ] && cp /usr/ubifs/etc/motd /etc/motd

# Create shell wrapper to ensure /usr/ubifs/bin is in PATH for Dropbear non-interactive sessions (SCP)
cat << 'SHELL_EOF' > /etc/sh
#!/bin/sh
export PATH="/custom_app/bin:/usr/ubifs/bin:/userfs/bin:/usr/sbin:/bin:/usr/bin:/sbin"
exec /bin/sh "$@"
SHELL_EOF
chmod 755 /etc/sh

# Register shell in /etc/shells so Dropbear permits authentication
cat << 'SHELLS_EOF' > /etc/shells
/bin/sh
/etc/sh
SHELLS_EOF

# Update superadmin and admin shell in RAM passwd to use wrapper
sed -i 's|:/bin/sh|:/etc/sh|g' /etc/passwd

# Set PATH for interactive login shells
cat << 'PROFILE_EOF' > /etc/profile
export PATH="/custom_app/bin:/usr/ubifs/bin:/userfs/bin:/usr/sbin:/bin:/usr/bin:/sbin"
export TERMINFO="/custom_app/share/mini-terminfo"
PROFILE_EOF

# Generate host keys if not present
[ ! -f /usr/ubifs/etc/dropbear/dropbear_rsa_host_key ] && /usr/ubifs/bin/dropbearkey -t rsa -f /usr/ubifs/etc/dropbear/dropbear_rsa_host_key 2>/dev/null
[ ! -f /usr/ubifs/etc/dropbear/dropbear_ed25519_host_key ] && /usr/ubifs/bin/dropbearkey -t ed25519 -f /usr/ubifs/etc/dropbear/dropbear_ed25519_host_key 2>/dev/null
ln -sf /usr/ubifs/etc/dropbear/* /etc/dropbear/ 2>/dev/null

# 3. Read configured settings (from WebUI ssh.conf)
CONFIG_FILE="/usr/ubifs/etc/dropbear/ssh.conf"
ACL_FILE="/usr/ubifs/etc/dropbear/acl.conf"

ENABLED="1"
PORT="22"
INTERFACE="LAN"

if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
fi

[ -z "$PORT" ] && PORT="22"
[ -z "$ENABLED" ] && ENABLED="1"
[ "$INTERFACE" != "WAN" ] && INTERFACE="LAN"

# 4. Apply Firewall & Start Dropbear if enabled
if [ -x /usr/ubifs/webupper/cgi-bin/ssh_ctl.cgi ]; then
    echo "action=refresh_fw" | REQUEST_METHOD="POST" /usr/ubifs/webupper/cgi-bin/ssh_ctl.cgi >/dev/null 2>&1
else
    # Fallback firewall setup
    iptables -N SSH_RULES 2>/dev/null
    iptables -F SSH_RULES
    if [ "$INTERFACE" = "WAN" ]; then
        IF_OPT="! -i br0"
    else
        IF_OPT="-i br0"
    fi
    if [ -s "$ACL_FILE" ]; then
        while read -r acl_ip; do
            [ -n "$acl_ip" ] || continue
            iptables -A SSH_RULES $IF_OPT -s "$acl_ip" -p tcp --dport "$PORT" -j ACCEPT 2>/dev/null
        done < "$ACL_FILE"
    else
        iptables -A SSH_RULES $IF_OPT -p tcp --dport "$PORT" -j ACCEPT 2>/dev/null
    fi
    iptables -A SSH_RULES -p tcp --dport "$PORT" -j DROP 2>/dev/null
    iptables -I INPUT 1 -p tcp -m tcp --dport "$PORT" -j SSH_RULES 2>/dev/null
fi

if [ "$ENABLED" = "1" ] || [ "$ENABLED" = "Yes" ]; then
    if ! netstat -tlne 2>/dev/null | grep -E ":$PORT\b" >/dev/null; then
        /usr/ubifs/bin/dropbear             -r /usr/ubifs/etc/dropbear/dropbear_rsa_host_key             -r /usr/ubifs/etc/dropbear/dropbear_ed25519_host_key             -p "$PORT"             -B 2>/dev/null || /usr/ubifs/bin/dropbear -p "$PORT" -B
    fi
fi

# 5. Background Watchdog Loop (Keeps Dropbear running & synchronizes state)
while true; do
    if [ -f "$CONFIG_FILE" ]; then
        . "$CONFIG_FILE"
    fi
    [ -z "$PORT" ] && PORT="22"
    [ -z "$ENABLED" ] && ENABLED="1"
    [ "$INTERFACE" != "WAN" ] && INTERFACE="LAN"

    if [ "$ENABLED" = "1" ] || [ "$ENABLED" = "Yes" ]; then
        if ! iptables -S INPUT 2>/dev/null | grep -E "dport $PORT\b.*SSH_RULES" >/dev/null; then
            if [ -x /usr/ubifs/webupper/cgi-bin/ssh_ctl.cgi ]; then
                echo "action=refresh_fw" | REQUEST_METHOD="POST" /usr/ubifs/webupper/cgi-bin/ssh_ctl.cgi >/dev/null 2>&1
            fi
        fi

        if ! netstat -tlne 2>/dev/null | grep -E ":$PORT\b" >/dev/null; then
            /usr/ubifs/bin/dropbear                 -r /usr/ubifs/etc/dropbear/dropbear_rsa_host_key                 -r /usr/ubifs/etc/dropbear/dropbear_ed25519_host_key                 -p "$PORT"                 -B 2>/dev/null || /usr/ubifs/bin/dropbear -p "$PORT" -B
        fi
    fi
    sleep 30
done &

# 6. Start Modern Services (Web Terminal & vnstatd Traffic Monitor)
if [ -x /custom_app/bin/vnstatd ] && ! ps | grep -v grep | grep -q "vnstatd"; then
    /custom_app/bin/vnstatd --config /custom_app/etc/vnstat.conf -d 2>/dev/null
fi

if [ -x /custom_app/bin/ttyd ] && ! ps | grep -v grep | grep -q "ttyd"; then
    /usr/ubifs/bin/busybox setsid /custom_app/bin/ttyd -W -p 7681 -c superadmin:lament /bin/sh >/dev/null 2>&1 &
fi
