local config = {
    default = false,
}

return setmetatable(config, {
    __call = function(c, o)
        for k, v in pairs(o) do
            c[k] = v
        end
    end,
})
