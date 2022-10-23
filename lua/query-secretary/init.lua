local M = {}
local ts = require("query-secretary.lib.tree-sitter")
local query_processing = require("query-secretary.lib.query-processing")
local window = require("query-secretary.lib.window")

local ns = vim.api.nvim_create_namespace("query-secretary")
vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

---- Functions -----------------------------------------------------------

local function query_blocks_to_window()
	local query_building_blocks = query_processing.gather_query_building_blocks()
	local lines_tbl = {}

	for i, block in ipairs(query_building_blocks) do
		table.insert(lines_tbl, string.rep("\t", i - 1) .. "(" .. block.node_type)
		if i == #query_building_blocks then
			lines_tbl[i] = lines_tbl[i] .. string.rep(")", i)
		end
	end

	local win, buf = window.open_center_window({
		open_win_opts = {
			width = 40,
			height = 15,
		},
		buf_set_opts = {
			filetype = "query",
			tabstop = 2,
			softtabstop = 2,
			shiftwidth = 2,
		},
	})

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines_tbl)
end

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
	query_blocks_to_window()
end, {})

return M
