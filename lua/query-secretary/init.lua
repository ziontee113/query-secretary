local M = {}
local ts = require("query-secretary.lib.tree-sitter")
local qw = require("query-secretary.business.query-window")

local ns = vim.api.nvim_create_namespace("query-secretary")
vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

---- Functions -----------------------------------------------------------

---- Keymaps -----------------------------------------------------------

vim.keymap.set("n", "<C-x><C-l>", function()
	ts.get_field_name_at_cursor()
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
	qw.query_window_initiate()
end, {})

return M
