#!/bin/sh

yay --needed -S \
    hyprland uwsm libnewt waybar hyprpaper hyprlock hypridle \
    dunst alacritty network-manager-applet \
    pcmanfm grim slurp wl-clipboard blueman \
    brightnessctl darkman geoclue

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

# NOTE: cannot use for root owned dirs! (e.g. /etc/conf.d)
CopyConfig() {
    TargetFile=$1
    MainPath="./${TargetFile}"
    DestinationDir=$2
    # Extracts just the filename from the path if $3 is empty
    OutputFileName=${3:-$(basename "$TargetFile")}

    mkdir -p "$DestinationDir"
    cp "$MainPath" "${DestinationDir}/${OutputFileName}"
    # Strip CRLF if needed
    sed -i 's/\r$//' "${DestinationDir}/${OutputFileName}"
}

# hyprland config
cp -r ./hypr/ "$XDG_CONFIG_HOME/"
cp ../../Assets/nasa.jpg "$XDG_CONFIG_HOME/hypr/"
cp ../../Assets/morfeu.jpg "$XDG_CONFIG_HOME/hypr/"
cp -r ./waybar/ "$XDG_CONFIG_HOME/"
cp ./misc/zprofile "$HOME/.zprofile"
systemctl --user enable hypridle.service
systemctl --user enable hyprpaper.service
sudo usermod -aG video,input $USER
echo "[*] Reboot is required for groups to refresh"
# dunst notification daemon
CopyConfig "./misc/dunstrc" "$XDG_CONFIG_HOME/dunst" "dunstrc"
# geoclue - D-Bus service for geolocation. Used for darkman
sudo cp ./misc/geoclue.conf /etc/geoclue/
# darkman - switch between light/dark mode depending on time
CopyConfig "./misc/darkman_config.yaml" "$XDG_CONFIG_HOME/darkman" "config.yaml"
systemctl --user enable --now darkman.service
