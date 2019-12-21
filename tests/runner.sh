#!/bin/bash

set -o nounset -o pipefail -o errexit

TABS_VS_SPACES=4
while getopts "t:-" OPT; do
    case $OPT in
        t) TABS_VS_SPACES=$OPTARG ;;
        -) break ;;
        ?) exit 2 ;;
    esac
done
shift $((OPTIND-1))

SCRIPT_DIR=$(readlink -f "$0" | xargs dirname)
ROOT=$SCRIPT_DIR/..
export EXAMPLES=$SCRIPT_DIR/examples

export TMP=$(mktemp -d)
trap 'rm -rf $TMP' EXIT

${VIM-vim} -i NONE -u NONE -U NONE -V1 -X -nNes \
    --cmd "set runtimepath=$SCRIPT_DIR/runtimepath,$ROOT,\$VIMRUNTIME" \
    --cmd 'set loadplugins' \
    -c"source $SCRIPT_DIR/asserts.vim" \
    -c"let g:tabs_vs_spaces = $TABS_VS_SPACES" \
    -c'source % | echo "" | qall!' -- "$@"
