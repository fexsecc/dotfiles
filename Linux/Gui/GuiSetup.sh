#!/bin/sh

yay --needed -S hyprland uwsm libnewt waybar hyprpaper hyprlock hypridle dunst alacritty

# -e — exit immediately if a command fails
# -u — treat unset variables as errors
# -x — print commands before executing them
set -eux

if [ "$(id -u)" -eq 0 ]; then
    echo "Error: this script must not be run as root." >&2
    exit 1
fi

# Change directory to the script's actual location
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"

cp -r ./hypr/ "$XDG_CONFIG_HOME/"
cp ./zprofile "$HOME/.zprofile"
