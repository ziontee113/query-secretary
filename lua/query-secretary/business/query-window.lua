local M = {}
local query_processing = require("query-secretary.lib.query-processing")
local window = require("query-secretary.lib.window")
local lua_utils = require("query-secretary.lib.lua-utils")

---- Functions -----------------------------------------------------------

local function _get_query_block_at_curor(win, query_building_blocks)
	local win_cur_line = vim.api.nvim_win_get_cursor(win)[1]
	for i, block in ipairs(query_building_blocks) do
		if block.lnum == win_cur_line then
			return i
		elseif block.lnum > win_cur_line then
			return i - 1
		end
	end
end

local default_predicates = { "eq", "any-of", "contains", "match", "lua-match" }
local function toggle_predicate_at_cursor(win, buf, query_building_blocks)
	local block_index = _get_query_block_at_curor(win, query_building_blocks)

	local current_predicate = query_building_blocks[block_index].predicate
	local predicate_index = lua_utils.tbl_index_of(default_predicates, current_predicate) or 0

	local new_predicate_index = lua_utils.increment_index_or_index_1(default_predicates, predicate_index, 1)
	query_building_blocks[block_index].predicate = default_predicates[new_predicate_index]

	-- TODO: render the change
end

local function handle_keymaps(win, buf, query_building_blocks)
	-- close floating window
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf })

	vim.keymap.set("n", "p", function()
		toggle_predicate_at_cursor(win, buf, query_building_blocks)
	end, { buffer = buf })
end

M.query_window_initiate = function()
	-- gather_query_building_blocks
	local query_building_blocks = query_processing.gather_query_building_blocks()

	-- update query window based on query_building_blocks
	local lines_tbl = query_processing.query_building_blocks_2_buffer_lines(query_building_blocks)

	-- open empty window with specified options
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

	-- set floating window text
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines_tbl)

	-- add mappings to floating window
	handle_keymaps(win, buf, query_building_blocks)

	return win, buf
end

return M
