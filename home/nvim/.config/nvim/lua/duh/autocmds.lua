local group = vim.api.nvim_create_augroup("duh", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	group = group,
	command = "checktime",
})
