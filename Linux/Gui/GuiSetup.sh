#!/bin/sh

yay --needed -S \
    hyprland uwsm libnewt waybar \
    hyprpaper   hyprlock hypridle \
    dunst alacritty    network-manager-applet \
    pcmanfm-qt grim slurp wl-clipboard blueman \
    brightnessctl    darkman xdg-desktop-portal \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk  \
    zathura zathura-pdf-mupdf mpv ungoogled-chromium-bin \
    pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber  \
    vesktop-bin pavucontrol pamixer otf-font-awesome gvfs-smb darkman \
    kvantum qt5-wayland qt6-wayland papirus-icon-theme power-profiles-daemon

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
# darkman - switch between light/dark mode depending on sunset
CopyConfig "./misc/darkman/config.yaml" "$XDG_CONFIG_HOME/darkman"
# For some reason uses XDG_DATA_HOME
CopyConfig "./misc/darkman/scripts/change_theme.sh" "$XDG_DATA_HOME/darkman"
systemctl --user enable darkman.service
systemctl --user restart darkman.service
# xdg-mime defaults for xdg-open
CopyConfig "./misc/mimeapps.list" "$XDG_CONFIG_HOME"
# Audio
systemctl --user enable --now pipewire pipewire-pulse wireplumber
# pcmanfm-qt config
CopyConfig "./misc/pcmanfm-qt/settings.conf" "$XDG_CONFIG_HOME/pcmanfm-qt/default/"
sed -i s/user123/$USER/g "$XDG_CONFIG_HOME/pcmanfm-qt/default/settings.conf"
# file picker bookmarks
CopyConfig "./misc/gtk-3.0/bookmarks" "$XDG_CONFIG_HOME/gtk-3.0/"
sed -i s/user123/$USER/g "$XDG_CONFIG_HOME/gtk-3.0/bookmarks"
