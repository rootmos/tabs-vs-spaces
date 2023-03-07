vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function(args)
        local ft = vim.opt.filetype:get()
        local C = require("tabs-vs-spaces.config")
        local c = C[ft]

        if c == false then
            return
        elseif c == nil then
            c = C.default
            if c == false then
                return
            end
        end

        require("tabs-vs-spaces")(args.buf, c)
    end,
})
