#!/bin/sh

set -eux

# Installs Nerd fonts
if [ "$(id -u)" -ne 0 ]; then
    echo "Root privileges are required to install fonts globally." >&2
    exit 1
fi

TEMP_DIR=$(mktemp -d)
FONT_DIR="/usr/local/share/fonts/JetBrainsMonoNF"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT HUP INT TERM

curl -L -f -o "$TEMP_DIR/font.zip" "$FONT_URL"
unzip -q "$TEMP_DIR/font.zip" -d "$TEMP_DIR"
mkdir -p "$FONT_DIR"
find "$TEMP_DIR" -name '*.ttf' -exec cp {} "$FONT_DIR/" \;
fc-cache -f
rm -rf "$TEMP_DIR"
