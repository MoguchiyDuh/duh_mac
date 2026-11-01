local function cargo_binary()
	local result = vim.system(
		{ "cargo", "metadata", "--no-deps", "--format-version", "1" },
		{ cwd = vim.fn.getcwd(), text = true }
	):wait()
	local fallback = vim.fn.getcwd() .. "/target/debug/"
	if result.code ~= 0 then
		return vim.fn.input("Executable: ", fallback, "file")
	end
	local ok, meta = pcall(vim.json.decode, result.stdout)
	if not ok or type(meta) ~= "table" then
		return vim.fn.input("Executable: ", fallback, "file")
	end
	local buffer = vim.api.nvim_buf_get_name(0)
	local best, depth = nil, -1
	for _, package in ipairs(meta.packages or {}) do
		local root = vim.fs.dirname(package.manifest_path)
		for _, target in ipairs(package.targets or {}) do
			if vim.tbl_contains(target.kind or {}, "bin") then
				local score = vim.startswith(buffer, root .. "/") and #root or 0
				if score > depth then
					best, depth = target.name, score
				end
			end
		end
	end
	local guess = best and (meta.target_directory .. "/debug/" .. best) or fallback
	return vim.fn.input("Executable: ", guess, "file")
end

local function rust_formatters()
	local sysroot = vim.system({ "rustc", "--print", "sysroot" }, { text = true }):wait()
	if sysroot.code ~= 0 then
		return {}
	end
	local etc = vim.trim(sysroot.stdout) .. "/lib/rustlib/etc"
	local commands = {}
	if vim.uv.fs_stat(etc .. "/lldb_lookup.py") then
		table.insert(commands, ("command script import '%s/lldb_lookup.py'"):format(etc))
	end
	if vim.uv.fs_stat(etc .. "/lldb_commands") then
		table.insert(commands, ("command source '%s/lldb_commands'"):format(etc))
	end
	return commands
end

return {
	parsers = { "rust", "ron" },
	lsp = {
		rust_analyzer = {
			bin = "rust-analyzer",
			config = { settings = { ["rust-analyzer"] = { check = { command = "clippy" } } } },
		},
	},
	format = { rust = { "rustfmt" } },
	dap = function(dap)
		dap.adapters["lldb-dap"] = { type = "executable", command = "xcrun", args = { "lldb-dap" }, name = "lldb-dap" }
		dap.configurations.rust = {
			{
				name = "Launch",
				type = "lldb-dap",
				request = "launch",
				program = cargo_binary,
				args = function()
					return require("dap.utils").splitstr(vim.fn.input("Args: "))
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				initCommands = rust_formatters,
			},
		}
	end,
}
