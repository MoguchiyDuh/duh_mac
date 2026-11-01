return {
	{
		"Saghen/blink.cmp",
		version = "*",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = { "rafamadriz/friendly-snippets" },
		opts = {
			keymap = {
				preset = "default",
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<C-e>"] = { "cancel" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},
			appearance = { nerd_font_variant = "mono" },
			sources = { default = { "lazydev", "lsp", "path", "snippets", "buffer" }, providers = {
				lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
			} },
			completion = { documentation = { auto_show = true, auto_show_delay_ms = 200 } },
			signature = { enabled = true },
		},
	},

	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = { "Saghen/blink.cmp" },
		config = function()
			vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
			for name, config in pairs(require("duh.lang").servers) do
				vim.lsp.config(name, config)
				vim.lsp.enable(name)
			end
		end,
	},
}
