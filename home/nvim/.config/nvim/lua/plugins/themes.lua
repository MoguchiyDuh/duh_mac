return {
	{ "folke/tokyonight.nvim" },
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "navarasu/onedark.nvim" },
	{ "rose-pine/neovim", name = "rose-pine" },
	{ "sainnhe/gruvbox-material" },
	{ "EdenEast/nightfox.nvim" },
	{ "sainnhe/everforest" },
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({ compile = false, terminalColors = true })
			require("duh.theme").setup()
		end,
	},
}
