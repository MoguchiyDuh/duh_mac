return {
	parsers = { "lua", "luadoc", "vim", "vimdoc", "query" },
	lsp = {
		lua_ls = {
			bin = "lua-language-server",
			config = {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
						telemetry = { enable = false },
						hint = { enable = true },
					},
				},
			},
		},
	},
	format = { lua = { "stylua" } },
	plugins = {
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
		},
	},
}
