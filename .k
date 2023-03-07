go() {
    LUA_PATH="../lua-hack/?.lua;lua/?.lua;lua/?/init.lua;$LUA_PATH" lua go.lua
}

run() {
    cat <<EOF | nvim -es -V1 "tests/examples/real-world.c"
q
EOF
}
