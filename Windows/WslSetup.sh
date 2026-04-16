#!/bin/bash

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

CopyConfig "zshrc" "$HOME" ".zshrc"
CopyConfig "tmux.conf" "$HOME/.config/tmux"
