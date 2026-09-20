#!/bin/sh

MODE="${1:-$(basename "$0")}"

case "$MODE" in
    *dark*)
        TARGET="dark"
        THEME="dark-theme"
        GTK_THEME="Adwaita-dark"
        COLOR_SCHEME="prefer-dark"
        MSG="Dark mode activated"
        ;;
    *light*)
        TARGET="light"
        THEME="light-theme"
        GTK_THEME="Adwaita"
        COLOR_SCHEME="prefer-light"
        MSG="Light mode activated"
        ;;
    *)
        echo "Unknown mode: $MODE" >&2
        exit 1
        ;;
esac

gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"

notify-send "Darkman theme selector" "$MSG"
