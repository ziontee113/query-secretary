local M = {}
local ts = require("query-secretary.lib.tree-sitter")

---@class query_building_block
---@field lnum number
---@field field_name string|nil
---@field node_type string
---@field node_text string
---@field predicate string

---gather *field_name* && *node_type* or current node at cursor
---up to the top most parent (below root)
---into `query_building_blocks[]`
---@return query_building_block[]
M.gather_query_building_blocks = function()
	local parents = ts.get_parent_nodes_at_cursor({ include_current_node = true })
	local query_building_blocks = {}

	-- gather building blocks for query_building_blocks
	for i = #parents, 1, -1 do
		local node_type = parents[i]:type()
		local field_name = ts.get_field_name_of_node(parents[i])
		local node_text = vim.treesitter.get_node_text(parents[i], 0)
		local index = #parents - i + 1

		---@type query_building_block
		local block = {
			node_type = node_type,
			field_name = field_name,
			node_text = node_text,
			lnum = index,
		}
		table.insert(query_building_blocks, block)
	end

	return query_building_blocks
end

M.query_building_blocks_2_buffer_lines = function(query_building_blocks)
	local lines_tbl = {}

	-- process output lines
	for i, block in ipairs(query_building_blocks) do
		table.insert(lines_tbl, string.rep("\t", i - 1) .. "(" .. block.node_type)
		if i == #query_building_blocks then
			lines_tbl[i] = lines_tbl[i] .. string.rep(")", i)
		end
	end

	return lines_tbl
end

return M
