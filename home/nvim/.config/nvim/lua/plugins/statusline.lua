return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = {
			options = {
				theme = "auto",
				globalstatus = true,
				component_separators = "",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "encoding", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},

	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = {
			options = {
				numbers = "ordinal",
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count)
					return "\u{f071} " .. count
				end,
				separator_style = "thin",
				always_show_bufferline = true,
			},
			highlights = function(defaults)
				local hl = {}
				for name in pairs(defaults.highlights) do
					hl[name] = { bg = { attribute = "bg", highlight = "TabLineFill" } }
					if name:find("separator") then
						hl[name].fg = { attribute = "fg", highlight = "WinSeparator" }
					end
				end
				return hl
			end,
		},
	},
}
