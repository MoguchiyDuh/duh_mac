local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local result = vim.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	}):wait()
	if result.code ~= 0 then
		error("lazy.nvim clone failed: " .. (result.stderr or ""))
	end
end
vim.opt.rtp:prepend(lazypath)

local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h")

local spec = { { import = "plugins" } }
vim.list_extend(spec, require("duh.lang").plugins)

require("lazy").setup({
	spec = spec,
	defaults = { lazy = true },
	install = { colorscheme = { "dynamic", "kanagawa-wave" } },
	checker = { enabled = false },
	change_detection = { enabled = false },
	ui = { border = "rounded" },
	performance = {
		rtp = {
			paths = { root },
			disabled_plugins = { "gzip", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
		},
	},
})
