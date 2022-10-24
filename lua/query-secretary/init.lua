local M = {}
local ts = require("query-secretary.lib.tree-sitter")
local business__query_window = require("query-secretary.business.query-window")

local ns = vim.api.nvim_create_namespace("query-secretary")
vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

---- Functions -----------------------------------------------------------

---- Keymaps -----------------------------------------------------------

vim.keymap.set("n", "<C-x><C-l>", function()
	local ts_utils = require("nvim-treesitter.ts_utils")
	N(ts_utils.get_node_at_cursor():type())
end, {})

vim.keymap.set("n", "<C-x><C-x>", function()
	vim.api.nvim_buf_set_extmark(0, ns, 0, 0, {
		virt_text = { { "a", "Normal" } },
		virt_text_pos = "overlay",
	})
end, {})

vim.keymap.set("n", "<C-x><C-c>", function()
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end, {})

vim.keymap.set({ "n", "x" }, "<C-x><C-n>", function()
	business__query_window.query_window_initiate()
end, {})

return M
