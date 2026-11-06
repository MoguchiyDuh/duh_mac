return {
	{
		"folke/snacks.nvim",
		priority = 900,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			dashboard = {
				preset = {
					keys = {
						{ icon = "\u{f002} ", key = "f", desc = "Find file", action = ":lua Snacks.picker.files()" },
						{ icon = "\u{f0b0} ", key = "g", desc = "Live grep", action = ":lua Snacks.picker.grep()" },
						{ icon = "\u{f1da} ", key = "r", desc = "Recent files", action = ":lua Snacks.picker.recent()" },
						{ icon = "\u{f07b} ", key = "e", desc = "Explorer", action = ":lua Snacks.explorer()" },
						{ icon = "\u{f013} ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
						{ icon = "\u{f011} ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
			},
			explorer = { enabled = true, replace_netrw = true },
			indent = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true, timeout = 3000 },
			picker = {
				enabled = true,
				sources = {
					explorer = {
						hidden = true,
						auto_close = true,
						jump = { close = true },
						layout = { preset = "default", preview = true },
						win = {
							input = { keys = { ["<C-n>"] = { "close", mode = { "n", "i" } } } },
							list = { keys = { ["<C-n>"] = "close" } },
						},
					},
					buffers = {
						win = {
							input = { keys = { ["<C-d>"] = { "bufdelete", mode = { "n", "i" } } } },
							list = { keys = { ["<C-d>"] = "bufdelete" } },
						},
					},
				},
			},
			scope = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
		keys = {
			{ "<C-n>", function() Snacks.explorer() end, desc = "Explorer" },
			{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
			{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
			{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
			{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
			{ "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
			{ "<leader>fp", function() Snacks.picker.commands() end, desc = "Commands" },
			{ "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
			{ "grr", function() Snacks.picker.lsp_references() end, desc = "References" },
			{ "gri", function() Snacks.picker.lsp_implementations() end, desc = "Implementations" },
			{ "grt", function() Snacks.picker.lsp_type_definitions() end, desc = "Type definition" },
			{ "gO", function() Snacks.picker.lsp_symbols() end, desc = "Document symbols" },
			{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Close buffer" },
			{ "<leader>gb", function() Snacks.gitbrowse() end, desc = "Open in browser" },
			{ "<leader>N", function() Snacks.notifier.show_history() end, desc = "Notification history" },
			{ "<leader>.", function() Snacks.scratch() end, desc = "Scratch buffer" },
		},
	},

	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						pcall(vim.cmd.cprevious)
					end
				end,
				desc = "Previous item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						pcall(vim.cmd.cnext)
					end
				end,
				desc = "Next item",
			},
		},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			spec = {
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code / colors" },
				{ "<leader>d", group = "debug" },
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>gc", group = "conflict" },
				{ "<leader>s", group = "split" },
				{ "<leader>u", group = "toggle" },
				{ "<leader>x", group = "trouble" },
			},
		},
	},
}
