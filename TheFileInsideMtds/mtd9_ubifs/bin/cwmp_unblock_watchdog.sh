#!/bin/sh
# -------------------------------------------------------------------------
# CWMP Port 9090 Exclusive ACL Watchdog
# Restricts GenieACS / TR-069 port 9090 exclusively to authorized host IPs:
#   - 192.168.1.69 (Host PC / GenieACS)
#   - 192.168.1.49 (Secondary Management Host)
# All other LAN / WAN clients attempting to reach port 9090 are DROPPED.
# -------------------------------------------------------------------------

ALLOWED_IPS="192.168.1.69 192.168.1.49"

while true; do
    # 1. Clean out any blanket/promiscuous ACCEPT rules from INPUT chain
    while iptables -D INPUT -p tcp --dport 9090 -j ACCEPT 2>/dev/null; do :; done
    while iptables -D INPUT -p udp --dport 9090 -j ACCEPT 2>/dev/null; do :; done

    # 2. Ensure INPUT chain has a jump to INPUT_block_cwmp_port
    if ! iptables -C INPUT -j INPUT_block_cwmp_port 2>/dev/null; then
        iptables -I INPUT 1 -j INPUT_block_cwmp_port 2>/dev/null
    fi

    # 3. Check if INPUT_block_cwmp_port matches our exclusive whitelist policy
    NEEDS_UPDATE=0
    for ip in $ALLOWED_IPS; do
        if ! iptables -C INPUT_block_cwmp_port -s "$ip" -p tcp --dport 9090 -j ACCEPT 2>/dev/null; then
            NEEDS_UPDATE=1
            break
        fi
    done

    if ! iptables -C INPUT_block_cwmp_port -p tcp --dport 9090 -j DROP 2>/dev/null; then
        NEEDS_UPDATE=1
    fi

    # 4. If rules are missing or vendor overwrote them with blanket DROP, rebuild chain
    if [ "$NEEDS_UPDATE" -eq 1 ]; then
        iptables -F INPUT_block_cwmp_port 2>/dev/null
        for ip in $ALLOWED_IPS; do
            iptables -A INPUT_block_cwmp_port -s "$ip" -p tcp --dport 9090 -j ACCEPT 2>/dev/null
            iptables -A INPUT_block_cwmp_port -s "$ip" -p udp --dport 9090 -j ACCEPT 2>/dev/null
        done
        # Drop all other connection requests to port 9090
        iptables -A INPUT_block_cwmp_port -p tcp --dport 9090 -j DROP 2>/dev/null
        iptables -A INPUT_block_cwmp_port -p udp --dport 9090 -j DROP 2>/dev/null
    fi

    sleep 2
done
