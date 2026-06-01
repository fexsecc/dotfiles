#!/bin/bash

set -eu

# Change directory to the script's actual location
cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# Install Nerd fonts
if [ "$(id -u)" -ne 0 ]; then
    echo "Root privileges are required to install fonts globally." >&2
    exit 1
fi
TEMP_DIR=$(mktemp -d)
FONT_DIR="/usr/local/share/fonts/JetBrainsMonoNF"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
curl -L -f -o "$TEMP_DIR/font.zip" "$FONT_URL"
unzip -q "$TEMP_DIR/font.zip" -d "$TEMP_DIR"
mkdir -p "$FONT_DIR"
find "$TEMP_DIR" -name '*.ttf' -exec cp {} "$FONT_DIR/" \;
fc-cache -f
rm -rf "$TEMP_DIR"

CopyConfig() {
    local TargetFile=$1
    local MainPath="./${TargetFile}"
    local DestinationDir=$2
    local OutputFileName=${3:-$TargetFile}

    /bin/mkdir -p "$DestinationDir"
    /bin/cp "$MainPath" "${DestinationDir}/${OutputFileName}"
    # Strip CRLF if needed
    /bin/sed -i 's/\r$//' "${DestinationDir}/${OutputFileName}"
}

# Configure zsh
CopyConfig "./Cli/zshrc" "$HOME" ".zshrc"
/bin/mkdir -p "$HOME/.config/zsh/"
/bin/touch "$HOME/.config/zsh/zsh_history"

# Configure alacritty
/bin/mkdir -p "$HOME/.config/alacritty/"
CopyConfig "./Cli/alacritty.toml" "$HOME/.config/alacritty" "alacritty.toml"

# Configure tmux and tpm plugins
CopyConfig "./Cli/tmux.conf" "$HOME/.config/tmux" "tmux.conf"
TpmDir="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TpmDir" ]; then
    /bin/git clone https://github.com/tmux-plugins/tpm "$TpmDir"
fi
"$TpmDir/bin/install_plugins"
"$TpmDir/bin/update_plugins" all
