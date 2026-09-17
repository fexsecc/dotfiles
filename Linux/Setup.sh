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

# QoL: Change back to initial dir
cd -
