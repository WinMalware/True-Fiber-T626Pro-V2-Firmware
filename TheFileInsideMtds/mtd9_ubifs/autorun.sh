#!/bin/sh
export PATH="/custom_app/bin:/usr/ubifs/bin:$PATH"

# Launch custom initialization hook in background
/usr/ubifs/custom_init.sh &
