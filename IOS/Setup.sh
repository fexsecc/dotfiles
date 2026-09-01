#!/var/jb/usr/bin/zsh

set -eu
# Change directory to the script's actual location
cd "${0:A:h}"

# Suppress bash locale warnings
export LC_ALL=C
export LANG=C


CopyConfig() {
    local TargetFile=$1
    local MainPath="./${TargetFile}"
    local DestinationDir=$2
    local OutputFileName=${3:-$TargetFile}

    mkdir -p "$DestinationDir"
    cp "$MainPath" "${DestinationDir}/${OutputFileName}"
    # Strip CRLF if needed
    sed -i 's/\r$//' "${DestinationDir}/${OutputFileName}"
}

# Configure zsh
CopyConfig "./zshrc" "$HOME" ".zshrc"
mkdir -p "$HOME/.config/zsh/"
touch "$HOME/.config/zsh/zsh_history"

# Configure tmux and tpm plugins
CopyConfig "./tmux.conf" "$HOME/.config/tmux" "tmux.conf"
TpmDir="$HOME/.config/tmux/plugins/tpm"
if [ ! -d "$TpmDir" ]; then
    git clone https://github.com/tmux-plugins/tpm "$TpmDir"
fi
# Force TPM to recognize the custom config and plugin paths
export TMUX_CONF="$HOME/.config/tmux/tmux.conf"
export TMUX_PLUGIN_MANAGER_PATH="$HOME/.config/tmux/plugins"
"$TpmDir/bin/install_plugins"
"$TpmDir/bin/update_plugins" all
