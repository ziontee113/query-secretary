---@diagnostic disable: undefined-global, need-check-nil
local M = {}
local ts = require("query-secretary.lib.tree-sitter")
local window = require("query-secretary.lib.window")

local ns = vim.api.nvim_create_namespace("query-secretary")
vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

local function extmark_self_and_parents()
	local parents = ts.get_parent_nodes_at_cursor({ include_current_node = true })
	local result_query = ""

	for i = #parents, 1, -1 do
		local new_line = i > 1 and "\n" or ""

		local content = parents[i]:type()
		content = string.rep("\t", #parents - i) .. "(" .. content

		result_query = result_query .. content .. new_line
		if i == 1 then
			result_query = result_query .. string.rep(")", #parents)
		end
	end

	N(result_query)
end

vim.keymap.set("n", "<C-x><C-x>", function()
	vim.api.nvim_buf_set_extmark(0, ns, 0, 0, {
		virt_text = { { "a", "Normal" } },
		virt_text_pos = "overlay",
	})
end, {})

vim.keymap.set("n", "<C-x><C-c>", function()
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end, {})

vim.keymap.set("n", "<C-x><C-p>", function()
	window.open_center_window({ height = 15 })
end, {})

vim.keymap.set({ "n", "x" }, "<C-x><C-n>", function()
	extmark_self_and_parents()
end, {})

return M
