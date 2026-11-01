return {
	parsers = { "c", "cpp", "cmake", "make" },
	lsp = {
		clangd = {
			bin = "clangd",
			config = {
				cmd = { "clangd", "--background-index", "--clang-tidy", "--offset-encoding=utf-16" },
				root_markers = { ".clangd", "compile_commands.json", "CMakeLists.txt", "Makefile", ".git" },
			},
		},
	},
	format = { c = { "clang-format" }, cpp = { "clang-format" } },
	dap = function(dap)
		dap.adapters["lldb-dap"] = { type = "executable", command = "xcrun", args = { "lldb-dap" }, name = "lldb-dap" }
		local function program()
			return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
		end
		local launch = {
			{
				name = "Launch",
				type = "lldb-dap",
				request = "launch",
				program = program,
				args = function()
					return require("dap.utils").splitstr(vim.fn.input("Args: "))
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
			{
				name = "Attach to debugserver",
				type = "lldb-dap",
				request = "attach",
				program = program,
				attachCommands = function()
					return { "gdb-remote " .. vim.fn.input("Remote target: ", "localhost:1234") }
				end,
			},
		}
		dap.configurations.c = launch
		dap.configurations.cpp = launch
		dap.configurations.objc = launch
	end,
}
