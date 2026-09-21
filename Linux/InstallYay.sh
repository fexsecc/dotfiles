#!/bin/sh
set -eu

is_arch_based() {
    if [ ! -f /etc/os-release ]; then
        return 1
    fi

    # Read OS release metadata
    # shellcheck disable=SC1091
    . /etc/os-release

    if [ "${ID:-}" = "arch" ]; then
        return 0
    fi

    case " ${ID_LIKE:-} " in
        *" arch "*) return 0 ;;
        *) return 1 ;;
    esac
}

if ! is_arch_based; then
    echo "Error: This script is intended only for Arch Linux or Arch-based distributions." >&2
    exit 1

fi


if command -v yay >/dev/null 2>&1; then
    echo "yay is already installed: $(command -v yay)"
    exit 0
fi

# makepkg cannot run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "Error: Run this script as a regular user with sudo privileges, not root." >&2
    exit 1
fi

echo "yay not found. Installing..."

sudo pacman -S --needed --noconfirm base-devel git

BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT INT TERM HUP
git clone https://aur.archlinux.org/yay.git "$BUILD_DIR/yay"
cd "$BUILD_DIR/yay"
makepkg -si --noconfirm
cd -
rm -rf "$BUILD_DIR"
echo "yay installed successfully."
