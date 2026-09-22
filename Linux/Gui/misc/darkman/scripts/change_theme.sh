#!/bin/sh

MODE="${1:-$(basename "$0")}"

case "$MODE" in
    *dark*)
        TARGET="dark"
        THEME="dark-theme"
        GTK_THEME="Adwaita-dark"
        COLOR_SCHEME="prefer-dark"
        KV_THEME="KvArcDark"
        NVIM_THEME="github_dark_high_contrast"
        MSG="Dark mode activated"
        ;;
    *light*)
        TARGET="light"
        THEME="light-theme"
        GTK_THEME="Adwaita"
        COLOR_SCHEME="prefer-light"
        KV_THEME="KvArc"
        NVIM_THEME="github_light_high_contrast"
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

# Apply alacritty theme
if [ "$TARGET" = "dark" ]; then
    ln -sf ~/.config/alacritty/dark.toml ~/.config/alacritty/theme.toml
elif [ "$TARGET" = "light" ]; then
    ln -sf ~/.config/alacritty/light.toml ~/.config/alacritty/theme.toml
fi

# Apply neovim theme
echo "vim.cmd('colorscheme $NVIM_THEME')" > ~/.config/nvim/lua/current_theme.lua
for server in "${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"/nvim.*; do
    if [ -S "$server" ]; then
        nvim --server "$server" --remote-expr "execute('colorscheme $NVIM_THEME')" >/dev/null 2>&1
    fi
done

notify-send "Darkman theme selector" "$MSG"
