return {
	parsers = { "python", "requirements" },
	lsp = {
		ty = {
			bin = "ty",
			config = { settings = { ty = { diagnosticMode = "openFilesOnly" } } },
		},
		ruff = {
			bin = "ruff",
			config = {
				on_attach = function(client)
					client.server_capabilities.hoverProvider = false
				end,
			},
		},
	},
	format = { python = { "ruff_format", "ruff_organize_imports" } },
	plugins = {
		{
			"mfussenegger/nvim-dap-python",
			ft = "python",
			dependencies = { "mfussenegger/nvim-dap" },
			config = function()
				require("dap-python").setup("uv")
			end,
		},
	},
}
