#!/bin/sh

case "$1" in
    dark)
        THEME="dark-theme"
        MSG="Dark mode activated"
        ;;
    light)
        THEME="light-theme"
        MSG="Light mode activated"
        ;;
    *)
        echo "Usage: $0 {dark|light}" >&2
        exit 1
        ;;
esac

notify-send "Darkman theme selector" "$MSG"
