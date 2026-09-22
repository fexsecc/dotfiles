#!/bin/sh

MODE="${1:-$(basename "$0")}"

case "$MODE" in
    *dark*)
        TARGET="dark"
        THEME="dark-theme"
        GTK_THEME="Adwaita-dark"
        COLOR_SCHEME="prefer-dark"
        KV_THEME="KvArcDark"
        MSG="Dark mode activated"
        ;;
    *light*)
        TARGET="light"
        THEME="light-theme"
        GTK_THEME="Adwaita"
        COLOR_SCHEME="prefer-light"
        KV_THEME="KvArc"
        MSG="Light mode activated"
        ;;
    *)
        echo "Unknown mode: $MODE" >&2
        exit 1
        ;;
esac

# Apply GTK and Portal themes
gsettings set org.gnome.desktop.interface color-scheme "$COLOR_SCHEME"
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"

# Apply Qt / Kvantum themes
kvantummanager --set "$KV_THEME"

if [ "$TARGET" = "dark" ]; then
    ln -sf ~/.config/alacritty/dark.toml ~/.config/alacritty/theme.toml
elif [ "$TARGET" = "light" ]; then
    ln -sf ~/.config/alacritty/light.toml ~/.config/alacritty/theme.toml
fi

notify-send "Darkman theme selector" "$MSG"
