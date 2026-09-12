#!/bin/bash

set -eu

# Change directory to the script's actual location
cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# Setup gdb
mkdir -p ~/.config/gdb
rm -f ~/.gdbinit
cmd="sudo chown -R $USER:$USER /opt"
echo cmd
eval "$cmd"
git clone https://github.com/jerdna-regeiz/splitmind /opt/splitmind
# The order matters here, as splitmind
# expects pwndbg to be already sourced
cat ./gdb/vanilla_config >> ~/.config/gdb/gdbinit
# Install and source pwndbg
PY_VER=$(gdb -nx --batch -iex 'py import sysconfig; print(sysconfig.get_config_var("VERSION"))')
uv tool install --python=$PY_VER  git+https://github.com/pwndbg/pwndbg
echo "source $(uv tool dir)/pwndbg/share/pwndbg/gdbinit.py" >> ~/.config/gdb/gdbinit
cat ./gdb/splitmind_config >> ~/.config/gdb/gdbinit
cat ./gdb/pwndbg_config >> ~/.config/gdb/gdbinit
# QoL: Change back to initial dir
cd -
