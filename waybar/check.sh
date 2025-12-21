#!/bin/bash

# Query active window info
active=$(hyprctl activewindow -j)

# Extract fullscreen value (0 or 1)
fs=$(echo "$active" | grep -o '"fullscreen": [0-9]' | awk '{print $2}')

if [ "$fs" = "1" ]; then
    echo "⛶"
else
    echo ""
fi

