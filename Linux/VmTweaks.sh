#!/bin/sh

set -eux

# Higher scale for better readability
sed -i 's/scale = .*$/scale = 1.33,/g' "$XDG_CONFIG_HOME/hypr/hyprland.lua"
sudo pacman --needed -S firefox
sed -i 's/local browser = .*$/local browser = "firefox"/g' "$XDG_CONFIG_HOME/hypr/hyprland.lua"
