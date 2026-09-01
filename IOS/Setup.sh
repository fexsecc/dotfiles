#!/var/jb/usr/bin/zsh

set -eu
# Change directory to the script's actual location
cd "${0:A:h}"

# Suppress bash locale warnings
export LC_ALL=C
export LANG=C

# Needed pkgs
UpdCmd="sudo apt -y update && sudo apt -y upgrade; sudo apt install sed gawk tmux"
echo "$UpdCmd"
eval "$UpdCmd"


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

# Variables required for tmux to function on iOS
export LC_ALL="UTF-8"
export LANG="UTF-8"
export TMUX_TMPDIR="/tmp"

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
