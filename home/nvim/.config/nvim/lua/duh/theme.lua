local M = {}

local light = {
	["kanagawa-lotus"] = true,
	["tokyonight-day"] = true,
	["catppuccin-latte"] = true,
	["rose-pine-dawn"] = true,
	["dayfox"] = true,
	["dawnfox"] = true,
	["onedark-light"] = true,
}

local function colorscheme(name)
	return function(variant)
		vim.o.background = light[variant] and "light" or "dark"
		vim.cmd.colorscheme(variant or name)
	end
end

local function background_var(var, scheme)
	return function(variant)
		vim.g[var] = variant
		vim.g[var:gsub("_background$", "_better_performance")] = 1
		vim.o.background = "dark"
		vim.cmd.colorscheme(scheme)
	end
end

M.themes = {
	dynamic = { variants = { "dynamic" }, apply = colorscheme("dynamic") },
	kanagawa = { variants = { "kanagawa-wave", "kanagawa-dragon", "kanagawa-lotus" }, apply = colorscheme("kanagawa-wave") },
	tokyonight = {
		variants = { "tokyonight-night", "tokyonight-storm", "tokyonight-moon", "tokyonight-day" },
		apply = colorscheme("tokyonight-night"),
	},
	catppuccin = {
		variants = { "catppuccin-mocha", "catppuccin-macchiato", "catppuccin-frappe", "catppuccin-latte" },
		apply = colorscheme("catppuccin-mocha"),
	},
	onedark = {
		variants = { "onedark-dark", "onedark-darker", "onedark-cool", "onedark-deep", "onedark-warm", "onedark-warmer", "onedark-light" },
		apply = function(variant)
			local style = (variant or "onedark-dark"):gsub("^onedark%-", "")
			require("onedark").setup({ style = style })
			vim.o.background = style == "light" and "light" or "dark"
			require("onedark").load()
		end,
	},
	["rose-pine"] = { variants = { "rose-pine-main", "rose-pine-moon", "rose-pine-dawn" }, apply = colorscheme("rose-pine-main") },
	["gruvbox-material"] = { variants = { "soft", "medium", "hard" }, apply = background_var("gruvbox_material_background", "gruvbox-material") },
	nightfox = {
		variants = { "nightfox", "carbonfox", "nordfox", "terafox", "duskfox", "dayfox", "dawnfox" },
		apply = colorscheme("nightfox"),
	},
	everforest = { variants = { "soft", "medium", "hard" }, apply = background_var("everforest_background", "everforest") },
}

local transparent_groups = {
	"Normal", "NormalNC", "NormalFloat", "SignColumn", "StatusLine", "StatusLineNC", "EndOfBuffer",
	"CursorLine", "CursorLineNr", "LineNr", "LineNrAbove", "LineNrBelow", "WinSeparator", "FoldColumn",
	"SnacksNormal", "SnacksNormalNC", "SnacksWinBar", "SnacksWinBarNC", "SnacksPickerPickWin",
	"SnacksPickerPickWinCurrent", "WinBar", "WinBarNC",
}

local state_file = vim.fn.stdpath("state") .. "/duh-theme.json"
local state = { theme = "dynamic", variant = nil, transparent = false }

local function save()
	local file = io.open(state_file, "w")
	if file then
		file:write(vim.json.encode(state))
		file:close()
	end
end

local function restore()
	local file = io.open(state_file, "r")
	if not file then
		return
	end
	local ok, data = pcall(vim.json.decode, file:read("*a"))
	file:close()
	if ok and type(data) == "table" and M.themes[data.theme] then
		state.theme = data.theme
		state.variant = data.variant
		state.transparent = data.transparent == true
	end
end

local function clear_backgrounds()
	for _, name in ipairs(transparent_groups) do
		local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
		hl.bg, hl.ctermbg = nil, nil
		vim.api.nvim_set_hl(0, name, hl)
	end
end

local function dynamic_dirs()
	local state = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")
	local data = vim.env.XDG_DATA_HOME or (vim.env.HOME .. "/.local/share")
	for _, dir in ipairs({ state .. "/duh/theme/nvim", data .. "/duh/nvim", data .. "/nvim/site" }) do
		if vim.uv.fs_stat(dir .. "/colors/dynamic.lua") then
			vim.opt.rtp:append(dir)
			return true
		end
	end
	return false
end

function M.apply(name, variant)
	local theme = M.themes[name]
	if not theme then
		return
	end
	local ok, err = pcall(theme.apply, variant)
	if not ok then
		vim.notify("theme " .. name .. " failed: " .. tostring(err), vim.log.levels.WARN)
		if name ~= "kanagawa" then
			M.apply("kanagawa", "kanagawa-wave")
		end
		return
	end
	state.theme, state.variant = name, variant
	save()
end

local function confirm_light(variant, done)
	if not light[variant] then
		done()
		return
	end
	vim.ui.select({ "Yes", "No" }, { prompt = "Light theme, sure?" }, function(choice)
		if choice == "Yes" then
			done()
		end
	end)
end

local function pick_variant(name, done)
	local variants = M.themes[name].variants
	if #variants <= 1 then
		done(variants[1])
		return
	end
	vim.ui.select(variants, { prompt = "Variant" }, function(variant)
		if variant then
			confirm_light(variant, function()
				done(variant)
			end)
		end
	end)
end

function M.setup()
	dynamic_dirs()
	restore()

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("duh-theme", { clear = true }),
		callback = function()
			if state.transparent then
				clear_backgrounds()
			end
		end,
	})

	vim.api.nvim_create_autocmd("Signal", {
		group = "duh-theme",
		pattern = "SIGUSR1",
		nested = true,
		callback = function()
			if vim.g.colors_name == "dynamic" then
				vim.cmd.colorscheme("dynamic")
			end
		end,
	})

	vim.keymap.set("n", "<leader>ct", function()
		local names = vim.tbl_keys(M.themes)
		table.sort(names)
		vim.ui.select(names, { prompt = "Theme" }, function(name)
			if name then
				pick_variant(name, function(variant)
					M.apply(name, variant)
				end)
			end
		end)
	end, { desc = "Switch theme" })

	vim.keymap.set("n", "<leader>cv", function()
		local name = state.theme
		pick_variant(name, function(variant)
			M.apply(name, variant)
		end)
	end, { desc = "Switch variant" })

	vim.keymap.set("n", "<leader>cb", function()
		state.transparent = not state.transparent
		vim.cmd.colorscheme(vim.g.colors_name)
		vim.notify(state.transparent and "Transparency on" or "Transparency off")
		save()
	end, { desc = "Toggle transparency" })

	M.apply(state.theme, state.variant)
end

return M
