#!/bin/sh

DROPBEAR_BIN="/usr/ubifs/bin/dropbear"
KEYGEN_BIN="/usr/ubifs/bin/dropbearkey"
CONFIG_DIR="/usr/ubifs/etc/dropbear"
CONFIG_FILE="$CONFIG_DIR/ssh.conf"
ACL_FILE="$CONFIG_DIR/acl.conf"

mkdir -p "$CONFIG_DIR"
[ ! -f "$ACL_FILE" ] && : > "$ACL_FILE"

# -------------------------------------------------------------
# Read & Parse Request Data
# -------------------------------------------------------------
if [ "$REQUEST_METHOD" = "POST" ]; then
    read -r POST_DATA
    QUERY_STRING="$POST_DATA"
fi

get_param() {
    echo "$QUERY_STRING" | awk -F"&" -v k="$1" '{for(i=1;i<=NF;i++){split($i,a,"="); if(a[1]==k) print a[2]}}' | sed 's/%20/ /g;s/+/ /g;s/%2F/\//g;s/%3A/:/g;s/%2C/,/g'
}

ACTION=$(get_param "action")
REQ_PORT=$(get_param "port")
REQ_ENABLED=$(get_param "enabled")
REQ_INTERFACE=$(get_param "interface")
IP_ENTRY=$(get_param "ip")
DEL_IPS=$(get_param "del_ips")

# Load existing configuration
ENABLED="1"
PORT="22"
INTERFACE="LAN"

if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
fi

OLD_PORT="$PORT"
OLD_ENABLED="$ENABLED"

# Strictly remove BOTH option: Interface can ONLY be LAN or WAN
[ "$INTERFACE" != "WAN" ] && INTERFACE="LAN"
[ -z "$PORT" ] && PORT="22"
[ -z "$ENABLED" ] && ENABLED="1"

# -------------------------------------------------------------
# Firewall Application Function
# -------------------------------------------------------------
apply_iptables() {
    p="$PORT"
    iptables -N SSH_RULES 2>/dev/null
    iptables -F SSH_RULES

    # Remove any direct ACCEPT rules on port
    while iptables -D INPUT -p tcp --dport "$p" -j ACCEPT 2>/dev/null; do :; done
    while iptables -D INPUT -i br0 -p tcp --dport "$p" -j ACCEPT 2>/dev/null; do :; done
    while iptables -D INPUT ! -i br0 -p tcp --dport "$p" -j ACCEPT 2>/dev/null; do :; done

    # Ensure jump rule exists from INPUT to SSH_RULES
    if ! iptables -S INPUT 2>/dev/null | grep -E "dport $p\b.*SSH_RULES" >/dev/null; then
        while iptables -D INPUT -p tcp -m tcp --dport "$p" -j SSH_RULES 2>/dev/null; do :; done
        iptables -I INPUT 1 -p tcp -m tcp --dport "$p" -j SSH_RULES
    fi

    # Clean old port jump rule if port changed
    if [ -n "$OLD_PORT" ] && [ "$OLD_PORT" != "$p" ]; then
        while iptables -D INPUT -p tcp -m tcp --dport "$OLD_PORT" -j SSH_RULES 2>/dev/null; do :; done
        while iptables -D INPUT -p tcp --dport "$OLD_PORT" -j ACCEPT 2>/dev/null; do :; done
        while iptables -D INPUT -i br0 -p tcp --dport "$OLD_PORT" -j ACCEPT 2>/dev/null; do :; done
        while iptables -D INPUT ! -i br0 -p tcp --dport "$OLD_PORT" -j ACCEPT 2>/dev/null; do :; done
    fi

    if [ "$ENABLED" = "1" ] || [ "$ENABLED" = "Yes" ]; then
        if [ "$INTERFACE" = "WAN" ]; then
            IF_OPT="! -i br0"
        else
            IF_OPT="-i br0"
        fi

        if [ -s "$ACL_FILE" ]; then
            while read -r acl_ip; do
                [ -n "$acl_ip" ] || continue
                iptables -A SSH_RULES $IF_OPT -s "$acl_ip" -p tcp --dport "$p" -j ACCEPT 2>/dev/null
            done < "$ACL_FILE"
        else
            iptables -A SSH_RULES $IF_OPT -p tcp --dport "$p" -j ACCEPT 2>/dev/null
        fi

        # Drop anything else hitting the SSH port
        iptables -A SSH_RULES -p tcp --dport "$p" -j DROP 2>/dev/null
    else
        # Disabled: drop all traffic to SSH port
        iptables -A SSH_RULES -p tcp --dport "$p" -j DROP 2>/dev/null
    fi
}

# -------------------------------------------------------------
# Action: GET Configuration (JSON)
# -------------------------------------------------------------
if [ "$ACTION" = "get" ] || [ -z "$ACTION" -a "$REQUEST_METHOD" = "GET" ]; then
    echo "Content-Type: application/json"
    echo ""
    json_acls=""
    if [ -f "$ACL_FILE" ]; then
        while read -r line; do
            [ -n "$line" ] || continue
            if [ -z "$json_acls" ]; then
                json_acls="\"$line\""
            else
                json_acls="$json_acls,\"$line\""
            fi
        done < "$ACL_FILE"
    fi
    echo "{\"enabled\":\"$ENABLED\",\"port\":\"$PORT\",\"interface\":\"$INTERFACE\",\"acls\":[$json_acls]}"
    exit 0
fi

# -------------------------------------------------------------
# Handle Actions
# -------------------------------------------------------------
restart_dropbear=0

if [ "$ACTION" = "apply" ]; then
    [ -n "$REQ_PORT" ] && PORT="$REQ_PORT"
    [ -n "$REQ_ENABLED" ] && ENABLED="$REQ_ENABLED"
    [ -n "$REQ_INTERFACE" ] && INTERFACE="$REQ_INTERFACE"

    # Strictly enforce: ONLY LAN or WAN (NO "Both")
    [ "$INTERFACE" != "WAN" ] && INTERFACE="LAN"
    [ -z "$PORT" ] && PORT="22"
    [ -z "$ENABLED" ] && ENABLED="1"

    echo "ENABLED=$ENABLED" > "$CONFIG_FILE"
    echo "PORT=$PORT" >> "$CONFIG_FILE"
    echo "INTERFACE=$INTERFACE" >> "$CONFIG_FILE"

    if [ "$OLD_PORT" != "$PORT" ] || [ "$OLD_ENABLED" != "$ENABLED" ]; then
        restart_dropbear=1
    fi

elif [ "$ACTION" = "add_acl" ]; then
    if [ -n "$IP_ENTRY" ]; then
        # Check if already present using exact awk comparison
        if ! awk -v t="$IP_ENTRY" '$0 == t {found=1} END {exit !found}' "$ACL_FILE" 2>/dev/null; then
            echo "$IP_ENTRY" >> "$ACL_FILE"
        fi
    fi

elif [ "$ACTION" = "del_selected" ]; then
    if [ -n "$DEL_IPS" ] && [ -f "$ACL_FILE" ]; then
        awk -v targets="$DEL_IPS" 'BEGIN{split(targets,a,","); for(i in a) del[a[i]]=1} !del[$0]' "$ACL_FILE" > "$ACL_FILE.tmp" 2>/dev/null
        mv "$ACL_FILE.tmp" "$ACL_FILE"
    fi

elif [ "$ACTION" = "del_all" ] || [ "$ACTION" = "clear_acl" ]; then
    > "$ACL_FILE"
fi

# Apply firewall rules
apply_iptables

# -------------------------------------------------------------
# Dropbear Service State Management
# -------------------------------------------------------------
if [ "$ENABLED" = "1" ] || [ "$ENABLED" = "Yes" ]; then
    # Ensure Dropbear host keys exist
    [ ! -f "$CONFIG_DIR/dropbear_rsa_host_key" ] && "$KEYGEN_BIN" -t rsa -f "$CONFIG_DIR/dropbear_rsa_host_key" 2>/dev/null
    [ ! -f "$CONFIG_DIR/dropbear_ed25519_host_key" ] && "$KEYGEN_BIN" -t ed25519 -f "$CONFIG_DIR/dropbear_ed25519_host_key" 2>/dev/null
    ln -sf "$CONFIG_DIR"/* /etc/dropbear/ 2>/dev/null

    # Check if Dropbear is listening on PORT
    is_listening=$(netstat -tlne 2>/dev/null | grep -E ":$PORT\b")

    if [ "$restart_dropbear" = "1" ] || [ -z "$is_listening" ]; then
        killall dropbear 2>/dev/null
        killall dropbearmulti 2>/dev/null
        sleep 1
        "$DROPBEAR_BIN" \
            -r "$CONFIG_DIR/dropbear_rsa_host_key" \
            -r "$CONFIG_DIR/dropbear_ed25519_host_key" \
            -p "$PORT" \
            -B 2>/dev/null || "$DROPBEAR_BIN" -p "$PORT" -B
    fi
else
    # Disabled
    killall dropbear 2>/dev/null
    killall dropbearmulti 2>/dev/null
fi

# -------------------------------------------------------------
# Output Response
# -------------------------------------------------------------
if [ "$REQUEST_METHOD" = "POST" ] && [ "$ACTION" != "apply" ]; then
    echo "Content-Type: application/json"
    echo ""
    echo '{"status":"ok"}'
    exit 0
fi

echo "Status: 302 Found"
echo "Location: /cgi-bin/true-page/service/SSH-Configuration.asp?saved=1"
echo "Content-Type: text/html"
echo ""
echo "<html><body>Redirecting...</body></html>"
