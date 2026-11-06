return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").install(require("duh.lang").parsers)
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("duh-treesitter", { clear = true }),
				callback = function(ev)
					if pcall(vim.treesitter.start, ev.buf) then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},

	{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },

	{
		"nvim-mini/mini.ai",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ a = "@block.outer", i = "@block.inner" }),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
				},
			}
		end,
	},

	{ "nvim-mini/mini.pairs", event = "VeryLazy", opts = {} },
	{ "kylechui/nvim-surround", event = "VeryLazy", opts = {} },

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
		keys = {
			{ "]h", function() require("gitsigns").nav_hunk("next") end, desc = "Next hunk" },
			{ "[h", function() require("gitsigns").nav_hunk("prev") end, desc = "Previous hunk" },
			{
				"<leader>gs",
				function() require("gitsigns").stage_hunk() end,
				mode = { "n", "v" },
				desc = "Stage hunk",
			},
			{ "<leader>gS", function() require("gitsigns").stage_buffer() end, desc = "Stage file" },
			{ "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage hunk" },
			{
				"<leader>gr",
				function() require("gitsigns").reset_hunk() end,
				mode = { "n", "v" },
				desc = "Reset hunk",
			},
			{ "<leader>gR", function() require("gitsigns").reset_buffer() end, desc = "Reset file" },
			{ "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
			{ "<leader>gl", function() require("gitsigns").blame_line() end, desc = "Blame line" },
			{ "<leader>gd", function() require("gitsigns").diffthis() end, desc = "Diff this file" },
		},
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{ "<leader>j", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash jump" },
			{ "<leader>J", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash treesitter" },
		},
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown" },
		opts = {},
		keys = {
			{
				"<leader>um",
				function()
					require("render-markdown").toggle()
				end,
				ft = "markdown",
				desc = "Toggle markdown preview",
			},
		},
	},

	{
		"lambdalisue/suda.vim",
		cmd = { "SudaRead", "SudaWrite" },
		init = function()
			vim.g.suda_smart_edit = 1
		end,
	},
}
