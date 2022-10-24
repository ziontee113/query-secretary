local M = {}
local query_processing = require("query-secretary.lib.query-processing")
local window = require("query-secretary.lib.window")
local lua_utils = require("query-secretary.lib.lua-utils")

---- Functions -----------------------------------------------------------

local default_predicates = { nil, "eq", "any-of", "contains", "match", "lua-match" }
local function toggle_predicate_at_cursor()
	local predicate_index = lua_utils.tbl_index_of(default_predicates, predicate?)
end

local function handle_keymaps(win, buf)
	-- close floating window
	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf })

	vim.keymap.set("n", "p", function()
		toggle_predicate_at_cursor()
	end, { buffer = buf })
end

M.query_window_initiate = function()
	-- gather_query_building_blocks
	local query_building_blocks = query_processing.gather_query_building_blocks()
	local lines_tbl = {}

	-- FIX: move this logic block elsewhere
	for i, block in ipairs(query_building_blocks) do
		table.insert(lines_tbl, string.rep("\t", i - 1) .. "(" .. block.node_type)
		if i == #query_building_blocks then
			lines_tbl[i] = lines_tbl[i] .. string.rep(")", i)
		end
	end

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

	-- add basic mappings to floating window
	handle_keymaps(win, buf)

	return win, buf
end

return M
