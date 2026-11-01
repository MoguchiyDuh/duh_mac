local map = vim.keymap.set

map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("n", "<C-q>", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>W", function()
	vim.b.duh_skip_format = true
	local ok, err = pcall(vim.cmd.write)
	vim.b.duh_skip_format = nil
	if not ok then
		vim.notify(tostring(err), vim.log.levels.ERROR)
	end
end, { desc = "Save without formatting" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force quit all" })

map("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear highlights" })

map("n", "<C-h>", "<C-w>h", { desc = "Left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Right split" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Taller split" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Shorter split" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Narrower split" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Wider split" })
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>ss", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "<leader>se", "<C-w>=", { desc = "Equal splits" })

map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
for i = 1, 9 do
	map("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Buffer " .. i })
end

map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })

map("n", "<leader>F", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })

map("n", "<leader>t", "<cmd>terminal<cr>", { desc = "Terminal" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })
