#!/bin/sh
[ -x /usr/ubifs/custom_init.sh ] && /usr/ubifs/custom_init.sh &

# ============================================================
# EtherWAN / Uplink LED State Daemon
# ============================================================

# ------------------------------------------------------------
# Bind custom web interfaces
# ------------------------------------------------------------

mount -o bind \
    /usr/ubifs/UplinkMode.asp \
    /boaroot/cgi-bin/true-page/other/UplinkMode.asp \
    2>/dev/null

mount -o bind \
    /usr/ubifs/config.js \
    /boaroot/html/scripts/app/config.js \
    2>/dev/null

# ------------------------------------------------------------
# Configure Ethernet uplink when EtherWAN is active
# ------------------------------------------------------------

TRANS_MODE=$(
    /userfs/bin/tcapi get Wan_Common TransMode 2>/dev/null
)

if [ "$TRANS_MODE" = "Ethernet" ] || \
   [ "$TRANS_MODE" = "ActiveEtherWan" ]; then

    brctl delif br0 eth0.5 2>/dev/null
    ifconfig eth0.5 up 2>/dev/null
fi

# ------------------------------------------------------------
# LED definitions
# ------------------------------------------------------------

LED_TEST="/proc/tc3162/led_test"

LED_INET_SOLID=33
LED_INET_ACT=34

LED_PON_SOLID=64
LED_PON_BLINK=65

LED_LOS_SOLID=66
LED_LOS_BLINK=67

# ------------------------------------------------------------
# LED control helper
# ------------------------------------------------------------

set_led() {
    echo "$1 $2" > "$LED_TEST" 2>/dev/null
}

# ------------------------------------------------------------
# Turn off all controlled LED modes
# ------------------------------------------------------------

set_led "off" "$LED_LOS_SOLID"
set_led "off" "$LED_LOS_BLINK"

set_led "off" "$LED_PON_SOLID"
set_led "off" "$LED_PON_BLINK"

set_led "off" "$LED_INET_SOLID"
set_led "off" "$LED_INET_ACT"

# ------------------------------------------------------------
# Initial state
# ------------------------------------------------------------

current_state="NONE"

# ------------------------------------------------------------
# Main state-monitoring loop
# ------------------------------------------------------------

while true; do

    # --------------------------------------------------------
    # Read physical 2.5G GPY211 PHY link status
    # --------------------------------------------------------

    PHY_STATUS=$(
        cat /proc/tc3162/hsgmii_lan_gphy211_link_status 2>/dev/null
    )

    # --------------------------------------------------------
    # Check whether PPPoE has obtained an IP address
    # --------------------------------------------------------

    HAS_INTERNET=0

    if ifconfig ppp0 2>/dev/null | grep -q "inet addr"; then
        HAS_INTERNET=1
    fi

    # --------------------------------------------------------
    # Determine desired state
    # --------------------------------------------------------

    target_state=""

    if [ "$PHY_STATUS" != "up" ]; then

        target_state="UNPLUGGED"

    elif [ "$HAS_INTERNET" = "1" ]; then

        target_state="ONLINE"

    else

        target_state="CONNECTING"

    fi

    # --------------------------------------------------------
    # Only update LEDs when the state changes
    # --------------------------------------------------------

    if [ "$target_state" != "$current_state" ]; then

        if [ "$target_state" = "UNPLUGGED" ]; then

            # CABLE UNPLUGGED: LOS blinking, PON/INET off
            set_led "off" "$LED_PON_SOLID"
            set_led "off" "$LED_PON_BLINK"
            set_led "off" "$LED_INET_SOLID"
            set_led "off" "$LED_INET_ACT"
            set_led "off" "$LED_LOS_SOLID"
            set_led "on" "$LED_LOS_BLINK"

        elif [ "$target_state" = "CONNECTING" ]; then

            # CABLE CONNECTED / AUTHENTICATING: PON blinking
            set_led "off" "$LED_LOS_SOLID"
            set_led "off" "$LED_LOS_BLINK"
            set_led "off" "$LED_INET_SOLID"
            set_led "off" "$LED_INET_ACT"
            set_led "off" "$LED_PON_SOLID"
            set_led "on" "$LED_PON_BLINK"

        elif [ "$target_state" = "ONLINE" ]; then

            # ONLINE: PON solid green, INET solid green
            set_led "off" "$LED_LOS_SOLID"
            set_led "off" "$LED_LOS_BLINK"
            set_led "off" "$LED_PON_BLINK"
            set_led "on" "$LED_PON_SOLID"
            set_led "on" "$LED_INET_SOLID"
            set_led "off" "$LED_INET_ACT"

        fi

        current_state="$target_state"
    fi

    # Poll once per second
    sleep 1

done
