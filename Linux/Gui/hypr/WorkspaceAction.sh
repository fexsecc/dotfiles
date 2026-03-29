#!/usr/bin/env bash

ActionType=$1
KeyInput=$2

ActiveMonitor=$(hyprctl activeworkspace -j | jq '.monitorID')
BaseWorkspace=$((ActiveMonitor * 10))
TargetWorkspace=$((BaseWorkspace + KeyInput))

hyprctl dispatch $ActionType $TargetWorkspace
