#!/bin/sh

set -eu

# Change directory to the script's actual location
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"

CopyConfig() {
    TargetFile=$1
    WslPath="./Wsl/${TargetFile}"
    FallbackPath="../Linux/Cli/${TargetFile}"
    DestinationDir=$2
    OutputFileName=${3:-$TargetFile}

    mkdir -p "$DestinationDir"


    if [ -f "$WslPath" ]; then
        cp "$WslPath" "${DestinationDir}/${OutputFileName}"
    elif [ -f "$FallbackPath" ]; then
        cp "$FallbackPath" "${DestinationDir}/${OutputFileName}"
    fi
    # Strip CRLF if needed
    sed -i 's/\r$//' "${DestinationDir}/${OutputFileName}"
}

# Configure zsh
CopyConfig "zshrc" "$HOME" ".zshrc"
mkdir -p "$HOME/.config/zsh/"
touch "$HOME/.config/zsh/zsh_history"
# Configure tmux and tpm plugins
CopyConfig "tmux.conf" "$HOME/.config/tmux"
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

