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
	if parents then -- TODO: implement our own ts_utils.get_node_at_cursor()
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
	end

	return query_building_blocks
end

---@param query_building_blocks query_building_block[]
---@return table: lines for `nvim_buf_set_lines`
M.query_building_blocks_2_buffer_lines = function(query_building_blocks)
	local lines_tbl = {}

	-- process output lines
	for i, block in ipairs(query_building_blocks) do
		table.insert(lines_tbl, string.rep("\t", i - 1) .. "(" .. block.node_type)
	end

	-- predicate handling
	local predicates_lines = {}
	local closing_parens_stack = ""
	for i, block in ipairs(query_building_blocks) do
		if not block.predicate then
			closing_parens_stack = closing_parens_stack .. ")"
		elseif block.predicate then
			local predicate_content = "@cap (#" .. block.predicate .. '? @cap "test")'
			local line = ") " .. predicate_content .. closing_parens_stack

			if i < #query_building_blocks then
				local tabs = string.rep("\t", i - 1)
				table.insert(predicates_lines, tabs .. line)
				closing_parens_stack = ""
			elseif i == #query_building_blocks then -- inner-most node
				closing_parens_stack = line
			end
		end
	end

	---- add part_2_lines to lines_tbl
	for i = #predicates_lines, 1, -1 do
		table.insert(lines_tbl, predicates_lines[i])
	end

	-- add closing_parens_stack to last line
	local i = #query_building_blocks
	lines_tbl[i] = lines_tbl[i] .. closing_parens_stack

	return lines_tbl
end

return M
