return {
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		cmd = "ConformInfo",
		opts = function()
			return {
				formatters_by_ft = require("duh.lang").formatters,
				format_on_save = function(bufnr)
					if vim.b[bufnr].duh_skip_format then
						return nil
					end
					return { timeout_ms = 1500, lsp_format = "fallback" }
				end,
			}
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = require("duh.lang").linters
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("duh-lint", { clear = true }),
				callback = function()
					lint.try_lint()
				end,
			})
			lint.try_lint()
		end,
	},
}
