#!/bin/sh

set -eux

# Higher scale for better readability
sed -i 's/scale = .*$/scale = 1.33,/g' "$XDG_CONFIG_HOME/hypr/hyprland.lua"
