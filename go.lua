local S = require("ser")

local P = require("tabs-vs-spaces")

print(P.inspect(io.open("tests/examples/real-world.c")):decide())
print(P.inspect(io.open("tests/examples/tiny-spaces.c")):decide())
print(P.inspect(io.open("tests/examples/tiny-tabs.c")):decide())
