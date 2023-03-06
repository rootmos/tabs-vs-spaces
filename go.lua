local S = require("ser")

local P = require("plugin")

local f = io.open("tests/examples/real-world.c")
print(S.pretty(P.inspect(f)))
