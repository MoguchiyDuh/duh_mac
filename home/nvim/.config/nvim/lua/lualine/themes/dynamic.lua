local function color(name, attr)
	local value = vim.api.nvim_get_hl(0, { name = name, link = false })[attr]
	return value and string.format("#%06x", value) or nil
end

local bar = color("TabLineFill", "bg")
local fg = color("Normal", "fg")
local muted = color("StatusLine", "fg")
local on_accent = color("TabLineSel", "fg")

local function mode(accent)
	return {
		a = { bg = accent, fg = on_accent, gui = "bold" },
		b = { bg = bar, fg = fg },
		c = { bg = bar, fg = muted },
	}
end

return {
	normal = mode(color("TabLineSel", "bg")),
	insert = mode(color("String", "fg")),
	visual = mode(color("Constant", "fg")),
	replace = mode(color("Error", "fg")),
	command = mode(color("WarningMsg", "fg")),
	inactive = {
		a = { bg = bar, fg = muted },
		b = { bg = bar, fg = muted },
		c = { bg = bar, fg = muted },
	},
}
