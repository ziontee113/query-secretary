local M = {}
local ts_utils = require("nvim-treesitter.ts_utils")

---return the `field_name` of passed in *tsnode*
---@param node userdata
---@return string|nil
M.get_field_name_of_node = function(node)
	local parent = node:parent()

	for children, field_name in parent:iter_children() do
		if children == node then
			return field_name
		end
	end
end

---get top most *(below root)* `ts-node` from the current cursor position
---@return ts-node | nil
M.get_top_node_at_cursor = function()
	local node = ts_utils.get_node_at_cursor()
	local root = ts_utils.get_root_for_node(node)

	local parent = node:parent()
	while parent ~= nil and parent ~= root do
		node = parent
		parent = node:parent()
		if parent == root then
			return node
		end
	end

	return nil
end

---@class parent_nodes_at_cursor_opts
---@field include_current_node boolean

---return *nil* | **table of parent nodes** of current node at cursor
---table *includes current node at cursor* if `opts.include_current_node` is `truthy`
---@param opts parent_nodes_at_cursor_opts
---@return table | nil
M.get_parent_nodes_at_cursor = function(opts)
	local return_tbl = {}
	local node = ts_utils.get_node_at_cursor()
	local root = ts_utils.get_root_for_node(node)

	if opts.include_current_node and node then
		table.insert(return_tbl, node)
	end

	local parent = node:parent()
	while parent ~= nil and parent ~= root do
		node = parent
		parent = node:parent()
		table.insert(return_tbl, node)
		if parent == root then
			return return_tbl
		end
	end

	return nil
end

return M
