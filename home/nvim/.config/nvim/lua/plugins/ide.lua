return {
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		opts = { headerMaxWidth = 80 },
		keys = {
			{
				"<leader>R",
				function()
					require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
				end,
				desc = "Search & replace (project)",
			},
			{
				"<leader>R",
				function()
					require("grug-far").with_visual_selection()
				end,
				mode = "x",
				desc = "Search & replace selection",
			},
		},
	},

	{
		"Bekaboo/dropbar.nvim",
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<leader>;", function() require("dropbar.api").pick() end, desc = "Breadcrumbs pick" },
		},
	},

	{
		"niekdomi/conflict.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("conflict").setup({
				default_mappings = {
					current = "<leader>gco",
					incoming = "<leader>gct",
					both = "<leader>gcb",
					base = "<leader>gcB",
					none = "<leader>gc0",
					next = "]x",
					prev = "[x",
				},
			})
		end,
	},
}
