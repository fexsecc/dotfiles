#!/bin/sh

set -eux

# Higher scale for better readability
sed -i 's/scale = .*$/scale = 1.33,/g' "$XDG_CONFIG_HOME/hypr/hyprland.lua"
# Use firefox by default inside vms
sudo pacman --needed -S firefox
sed -i 's/local browser = .*$/local browser = "firefox"/g' "$XDG_CONFIG_HOME/hypr/hyprland.lua"
# Disable suspend
sed -i '/systemctl suspend/d' "$XDG_CONFIG_HOME/hypr/hypridle.conf"
