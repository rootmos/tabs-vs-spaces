local lu = require("luaunit")
local L = require("tabs-vs-spaces")
local lines = require("lines")

local function inspect(fn)
    local f = io.open(fn)
    local st = L.inspect(lines(f))
    f:close()
    return st
end

function test_inspect_tiny_spaces()
    local e = inspect("examples/tiny-spaces.c")
    lu.assertEquals(e.lines, 4)
    lu.assertEquals(e.spaces, {[4]=1})
    lu.assertEquals(e.tabs, {})
    lu.assertEquals(e.mixed, 0)
end

function test_inspect_tiny_tabs()
    local e = inspect("examples/tiny-tabs.c")
    lu.assertEquals(e.lines, 4)
    lu.assertEquals(e.spaces, {})
    lu.assertEquals(e.tabs, {[1]=1})
    lu.assertEquals(e.mixed, 0)
end

function test_decision()
    lu.assertEquals(inspect("examples/tiny-spaces.c"):decide(), 4)
    lu.assertEquals(inspect("examples/tiny-tabs.c"):decide(), -1)

    lu.assertEquals(inspect("examples/real-world.c"):decide(), 4)
    lu.assertEquals(inspect("examples/pipeline.tf"):decide(), 2)
    lu.assertEquals(inspect("examples/neovim.c"):decide(), 2)
end

function test_nvim_plugin()
    local function run(fn)
        local cmd = "./nvim-test.sh " .. fn
        return load(io.popen(cmd):read("a"))()
    end

    lu.assertEquals(run("examples/tiny-spaces.c"), {
        decision = 4,
        expandtab = true,
        softtabstop = 4,
        shiftwidth = 4,
    })

    lu.assertEquals(run("examples/tiny-tabs.c"), {
        decision = -1,
        expandtab = false,
        softtabstop = 0,
        shiftwidth = 8,
    })

    lu.assertEquals(run("examples/real-world.c"), {
        decision = 4,
        expandtab = true,
        softtabstop = 4,
        shiftwidth = 4,
    })

    lu.assertEquals(run("examples/pipeline.c"), {
        decision = 2,
        expandtab = true,
        softtabstop = 2,
        shiftwidth = 2,
    })

    lu.assertEquals(run("examples/neovim.c"), {
        decision = 2,
        expandtab = true,
        softtabstop = 2,
        shiftwidth = 2,
    })
end

os.exit(lu.LuaUnit.run())
