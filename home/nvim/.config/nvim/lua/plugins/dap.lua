local function dap(method, ...)
	local args = { ... }
	return function()
		require("dap")[method](unpack(args))
	end
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
		keys = {
			{ "<F5>", dap("continue"), desc = "Debug: start/continue" },
			{ "<F9>", dap("toggle_breakpoint"), desc = "Debug: toggle breakpoint" },
			{ "<F10>", dap("step_over"), desc = "Debug: step over" },
			{ "<F11>", dap("step_into"), desc = "Debug: step into" },
			{ "<F12>", dap("step_out"), desc = "Debug: step out" },
			{ "<leader>db", dap("toggle_breakpoint"), desc = "Toggle breakpoint" },
			{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
			{ "<leader>dc", dap("continue"), desc = "Continue / start" },
			{ "<leader>dC", dap("run_to_cursor"), desc = "Run to cursor" },
			{ "<leader>di", dap("step_into"), desc = "Step into" },
			{ "<leader>do", dap("step_over"), desc = "Step over" },
			{ "<leader>dO", dap("step_out"), desc = "Step out" },
			{ "<leader>dp", dap("pause"), desc = "Pause" },
			{ "<leader>dr", dap("restart"), desc = "Restart" },
			{ "<leader>dt", dap("terminate"), desc = "Terminate" },
			{ "<leader>dl", dap("run_last"), desc = "Run last" },
			{ "<leader>dR", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
			{ "<leader>du", function() require("dapui").toggle() end, desc = "Toggle debug UI" },
			{ "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Eval expression" },
		},
		config = function()
			local d = require("dap")
			for _, setup in ipairs(require("duh.lang").dap) do
				setup(d)
			end

			vim.fn.sign_define("DapBreakpoint", { text = "\u{f111}", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "\u{f059}", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DapStopped", { text = "\u{f0da}", texthl = "DiagnosticOk", linehl = "Visual" })

			local ui = require("dapui")
			ui.setup({
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.5 },
							{ id = "breakpoints", size = 0.2 },
							{ id = "stacks", size = 0.15 },
							{ id = "watches", size = 0.15 },
						},
						size = 45,
						position = "left",
					},
					{
						elements = { { id = "repl", size = 0.5 }, { id = "console", size = 0.5 } },
						size = 12,
						position = "bottom",
					},
				},
			})
			d.listeners.after.event_initialized.duh = ui.open
			d.listeners.before.event_terminated.duh = ui.close
			d.listeners.before.event_exited.duh = ui.close
		end,
	},

	{
		"theHamsta/nvim-dap-virtual-text",
		opts = { commented = true, virt_text_pos = "eol" },
	},
}
