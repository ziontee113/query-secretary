local M = {}
local ts = require("query-secretary.lib.tree-sitter")
local user_defaults = require("query-secretary.user.defaults")

M.oldBuf = 0

---@class query_building_block
---@field lnum number
---@field tail number
---@field field_name string|nil
---@field display_field_name boolean|nil
---@field node userdata
---@field node_type string
---@field node_text string
---@field predicate string
---@field capture_group_name string

---gather *field_name* && *node_type* or current node at cursor
---up to the top most parent (below root)
---into `query_building_blocks[]`
---@return query_building_block[]
M.gather_query_building_blocks = function()
	local nodes = ts.get_parent_nodes_at_cursor({ include_current_node = true })
	local query_building_blocks = {}

	-- gather building blocks for query_building_blocks
	if nodes then -- TODO: implement our own ts_utils.get_node_at_cursor()
		for i = #nodes, 1, -1 do
			local node_type = nodes[i]:type()
			local field_name = ts.get_field_name_of_node(nodes[i])
			local node_text = vim.treesitter.get_node_text(nodes[i], 0)
			local index = #nodes - i + 1

			---@type query_building_block
			local block = {
				node_type = node_type,
				field_name = field_name,
				node_text = node_text,
				lnum = index,
				node = nodes[i],
			}
			table.insert(query_building_blocks, block)
		end
	end

	M.oldBuf = vim.api.nvim_get_current_buf()

	return query_building_blocks
end

---@param query_building_blocks query_building_block[]
---@return table: lines for `nvim_buf_set_lines`
M.query_building_blocks_2_buffer_lines = function(query_building_blocks)
	local lines_tbl = {}

	-- handle opening ( and node_type
	for i, block in ipairs(query_building_blocks) do
		local field_name = ""
		if block.display_field_name and block.field_name then
			field_name = block.field_name .. ":"
		end
		local content = string.rep("\t", i - 1) .. field_name .. "(" .. block.node_type
		table.insert(lines_tbl, content)
	end

	-- handle predicates
	local predicates_lines = {}
	local closing_parentacies_stack = ""

	-- for handling tails
	local __tails_tbl = {}
	local __tails_INDEX_tbl = {}

	for i, block in ipairs(query_building_blocks) do
		if not block.predicate then
			closing_parentacies_stack = closing_parentacies_stack .. ")"
		elseif block.predicate then
			-- show block.node_text as predicate_argument
			-- if block.node_text don't have any %s characters ( \n\t) etc..
			local predicate_argument = "test"
			if not string.match(block.node_text, "%s") then
				predicate_argument = block.node_text
			end

			-- handle toggling capture group names
			local capture_group_name
			if block.capture_group_name then
				capture_group_name = block.capture_group_name
			else
				capture_group_name = user_defaults.capture_group_names[1]
				block.capture_group_name = user_defaults.capture_group_names[1]
			end
			local predicate_content = "@"
				.. capture_group_name
				.. " (#"
				.. block.predicate
				.. "? @"
				.. capture_group_name
				.. ' "'
				.. predicate_argument
				.. '")'
			local line = ") " .. predicate_content .. closing_parentacies_stack

			-- handling tabs & tails
			if i < #query_building_blocks then
				local tabs = string.rep("\t", i - 1)
				table.insert(predicates_lines, tabs .. line)
				closing_parentacies_stack = ""

				-- handling tails
				table.insert(__tails_tbl, #query_building_blocks + #__tails_tbl + 1)
				table.insert(__tails_INDEX_tbl, i)
			elseif i == #query_building_blocks then -- inner-most node
				closing_parentacies_stack = line
			end
		end
	end

	-- handling tails
	for i, block_index in ipairs(__tails_INDEX_tbl) do
		local tail = __tails_tbl[#__tails_tbl - i + 1]
		query_building_blocks[block_index].tail = tail
	end

	---- add predicates_lines to lines_tbl
	for i = #predicates_lines, 1, -1 do
		table.insert(lines_tbl, predicates_lines[i])
	end

	-- add closing_parentacies_stack to last line of lines_tbl
	local i = #query_building_blocks
	lines_tbl[i] = lines_tbl[i] .. closing_parentacies_stack

	return lines_tbl
end

return M
