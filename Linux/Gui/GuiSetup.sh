#!/bin/sh

yay --needed -S hyprland uwsm libnewt waybar hyprpaper hyprlock hypridle dunst alacritty network-manager-applet pcmanfm

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

CopyConfig() {
    TargetFile=$1
    MainPath="./${TargetFile}"
    DestinationDir=$2
    OutputFileName=${3:-$TargetFile}

    mkdir -p "$DestinationDir"
    cp "$MainPath" "${DestinationDir}/${OutputFileName}"
    # Strip CRLF if needed
    sed -i 's/\r$//' "${DestinationDir}/${OutputFileName}"
}

cp -r ./hypr/ "$XDG_CONFIG_HOME/"
cp -r ./waybar/ "$XDG_CONFIG_HOME/"
cp ./zprofile "$HOME/.zprofile"

mkdir -p "$HOME/.config/dunst/"
CopyConfig "./dunstrc" "$HOME/.config/dunst" "dunstrc"
