local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.cursorline = true
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "cursor"
opt.showmode = false
opt.winborder = "rounded"
opt.laststatus = 3
opt.wrap = false
opt.mouse = "a"

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.inccommand = "split"

opt.clipboard = "unnamedplus"

opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.autoread = true

opt.updatetime = 200
opt.timeoutlen = 300

vim.diagnostic.config({
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "\u{f057}",
			[vim.diagnostic.severity.WARN] = "\u{f071}",
			[vim.diagnostic.severity.INFO] = "\u{f05a}",
			[vim.diagnostic.severity.HINT] = "\u{f0eb}",
		},
	},
})

vim.lsp.log.set_level("ERROR")
