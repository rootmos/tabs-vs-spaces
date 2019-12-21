#!/bin/bash

set -o nounset -o pipefail -o errexit

SCRIPT_DIR=$(readlink -f "$0" | xargs dirname)
ROOT=$SCRIPT_DIR/..
export EXAMPLES=$SCRIPT_DIR/examples

exec ${VIM-vim} -i NONE -u NONE -U NONE -V1 -X -nNes \
    --cmd "set runtimepath=$ROOT,\$VIMRUNTIME" \
    --cmd 'set loadplugins' \
    -c'source % | echo "" | qall!' -- "$@"
