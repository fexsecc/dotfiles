#!/bin/bash

set -eu

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
