return {
	parsers = { "go", "gomod", "gosum", "gowork" },
	lsp = {
		gopls = {
			bin = "gopls",
			config = {
				settings = {
					gopls = {
						gofumpt = true,
						staticcheck = true,
						analyses = { unusedparams = true, shadow = true },
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							constantValues = true,
							functionTypeParameters = true,
							parameterNames = true,
							rangeVariableTypes = true,
						},
					},
				},
			},
		},
	},
	plugins = {
		{
			"leoluz/nvim-dap-go",
			ft = "go",
			dependencies = { "mfussenegger/nvim-dap" },
			opts = {},
		},
	},
}
