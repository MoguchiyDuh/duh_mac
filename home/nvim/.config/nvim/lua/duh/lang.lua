local M = {
	names = {},
	parsers = {},
	servers = {},
	formatters = {},
	linters = {},
	plugins = {},
	dap = {},
}

local function executable(bin)
	return bin ~= nil and vim.fn.executable(bin) == 1
end

local function absorb(name, spec)
	table.insert(M.names, name)
	vim.list_extend(M.parsers, spec.parsers or {})
	vim.list_extend(M.plugins, spec.plugins or {})
	for server, def in pairs(spec.lsp or {}) do
		if executable(def.bin) then
			M.servers[server] = def.config or {}
		end
	end
	for ft, list in pairs(spec.format or {}) do
		M.formatters[ft] = list
	end
	for ft, list in pairs(spec.lint or {}) do
		local present = vim.tbl_filter(executable, list)
		if #present > 0 then
			M.linters[ft] = present
		end
	end
	if spec.dap then
		table.insert(M.dap, spec.dap)
	end
end

function M.load()
	local seen = {}
	for _, file in ipairs(vim.api.nvim_get_runtime_file("lua/duh/lang/*.lua", true)) do
		local name = vim.fn.fnamemodify(file, ":t:r")
		if not seen[name] then
			seen[name] = true
			local ok, spec = pcall(require, "duh.lang." .. name)
			if ok and type(spec) == "table" then
				absorb(name, spec)
			else
				vim.schedule(function()
					vim.notify("duh: language module " .. name .. " failed: " .. tostring(spec), vim.log.levels.ERROR)
				end)
			end
		end
	end
	table.sort(M.names)
end

return M
