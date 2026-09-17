#!/bin/sh

set -eu

# Change directory to the script's actual location
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"

# Install Nerd fonts
if [ "$(id -u)" -ne 0 ]; then
    echo "Root privileges are required to install fonts globally." >&2
    exit 1
fi

if [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    USER_HOME=${HOME:-/root}
fi

TEMP_DIR=$(mktemp -d)
FONT_DIR="/usr/local/share/fonts/JetBrainsMonoNF"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT HUP INT TERM

curl -L -f -o "$TEMP_DIR/font.zip" "$FONT_URL"
unzip -q "$TEMP_DIR/font.zip" -d "$TEMP_DIR"
mkdir -p "$FONT_DIR"
find "$TEMP_DIR" -name '*.ttf' -exec cp {} "$FONT_DIR/" \;
fc-cache -f
rm -rf "$TEMP_DIR"

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
CopyConfig "./Cli/zshrc" "$USER_HOME" ".zshrc"
mkdir -p "$USER_HOME/.config/zsh/"
touch "$USER_HOME/.config/zsh/zsh_history"

# Configure alacritty
mkdir -p "$USER_HOME/.config/alacritty/"
CopyConfig "./Cli/alacritty.toml" "$USER_HOME/.config/alacritty" "alacritty.toml"

# Configure tmux and tpm plugins
CopyConfig "./Cli/tmux.conf" "$USER_HOME/.config/tmux" "tmux.conf"
TpmDir="$USER_HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TpmDir" ]; then
    git clone https://github.com/tmux-plugins/tpm "$TpmDir"
fi
"$TpmDir/bin/install_plugins"
"$TpmDir/bin/update_plugins" all

# Setup GDB config
../Misc/setup_gdb.sh

# QoL: Change back to initial dir
cd -
