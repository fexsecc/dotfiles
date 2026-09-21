#!/bin/sh

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

# Make sure we have required packages
sudo pacman -S --needed zsh tmux fontconfig unzip nvim base-devel nodejs npm gdb uv eza bat

sudo ./SetupNerdFonts.sh

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

# Configure zsh
CopyConfig "./Cli/zshrc" "$HOME" ".zshrc"
mkdir -p "$HOME/.config/zsh/"
touch "$HOME/.config/zsh/zsh_history"

# Configure alacritty
mkdir -p "$HOME/.config/alacritty/"
CopyConfig "./Cli/alacritty.toml" "$HOME/.config/alacritty" "alacritty.toml"

# Configure tmux and tpm plugins
CopyConfig "./Cli/tmux.conf" "$HOME/.config/tmux" "tmux.conf"
TpmDir="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TpmDir" ]; then
    git clone https://github.com/tmux-plugins/tpm "$TpmDir"
fi
"$TpmDir/bin/install_plugins"
"$TpmDir/bin/update_plugins" all

# Setup GDB config
../Misc/setup_gdb.sh

# SSH config
mkdir -p "$HOME/.ssh/"
CopyConfig "../Misc/ssh_config" "$HOME/.ssh/" "config"

# QoL: Change back to initial dir
cd -
