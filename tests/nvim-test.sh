#!/bin/bash

set -o nounset -o pipefail -o errexit

SCRIPT_DIR=$(readlink -f "$0" | xargs dirname)
PLUGIN_DIR=$(readlink -f "$SCRIPT_DIR/..")

TMP=$(mktemp -d)
trap 'rm -rf $TMP' EXIT

NVIM=${NVIM-nvim}

ID=$(tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c8 || true)

CONFIG=$TMP/config
mkdir "$CONFIG"

cat <<EOF >"$CONFIG/init.lua"
vim.cmd('set runtimepath+=$PLUGIN_DIR')

require("tabs-vs-spaces.config") {
    default = 2,
}
EOF

SCRIPT=$TMP/go.lua
OUTPUT=$TMP/output
cat <<EOF > "$SCRIPT"
local b = vim.b
local bo = vim.bo
local f = io.open("$OUTPUT", "w")
f:write("return {")
f:write(string.format("decision = %s,", b.tabs_vs_spaces.decision))
f:write(string.format("expandtab = %s,", bo.expandtab))
f:write(string.format("softtabstop = %s,", bo.softtabstop))
f:write(string.format("shiftwidth = %s,", bo.shiftwidth))
f:write("}")
vim.cmd("q")
EOF

NVIM_APPNAME="nvim-$ID" $NVIM --headless -u "$CONFIG/init.lua" "$1" -S "$SCRIPT" +cq

cat "$OUTPUT"
