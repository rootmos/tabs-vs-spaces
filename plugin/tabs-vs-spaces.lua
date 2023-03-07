local L = require("tabs-vs-spaces")

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function(args)
		local ft = vim.opt.filetype:get()
		print(ft)
	end,
})
