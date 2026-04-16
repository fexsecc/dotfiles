#!/bin/bash

set -eu

CopyConfig() {
    local TargetFile=$1
    local WslPath="./Wsl/${TargetFile}"
    local FallbackPath="../Linux/Cli/${TargetFile}"
    local DestinationDir=$2
    local OutputFileName=${3:-$TargetFile}

    /bin/mkdir -p "$DestinationDir"


    if [ -f "$WslPath" ]; then
        /bin/cp "$WslPath" "${DestinationDir}/${OutputFileName}"
    elif [ -f "$FallbackPath" ]; then
        /bin/cp "$FallbackPath" "${DestinationDir}/${OutputFileName}"
    fi
    # Strip CRLF if needed
    /bin/sed -i 's/\r$//' "${DestinationDir}/${OutputFileName}"
}

# Configure zsh
CopyConfig "zshrc" "$HOME" ".zshrc"
/bin/mkdir -p "$HOME/.config/zsh/"
/bin/touch "$HOME/.config/zsh/zsh_history"
# Configure tmux and tpm plugins
CopyConfig "tmux.conf" "$HOME/.config/tmux"
TpmDir="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TpmDir" ]; then
    /bin/git clone https://github.com/tmux-plugins/tpm "$TpmDir"
fi
"$TpmDir/bin/install_plugins"
"$TpmDir/bin/update_plugins" all
