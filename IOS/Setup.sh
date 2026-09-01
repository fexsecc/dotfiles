#!/bin/bash

set -eu

# Change directory to the script's actual location
cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

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
CopyConfig "./zshrc" "$HOME" ".zshrc"
/bin/mkdir -p "$HOME/.config/zsh/"
/bin/touch "$HOME/.config/zsh/zsh_history"

# Configure tmux and tpm plugins
CopyConfig "./tmux.conf" "$HOME/.config/tmux" "tmux.conf"
TpmDir="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TpmDir" ]; then
    git clone https://github.com/tmux-plugins/tpm "$TpmDir"
fi
"$TpmDir/bin/install_plugins"
"$TpmDir/bin/update_plugins" all
