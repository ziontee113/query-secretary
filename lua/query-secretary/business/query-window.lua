local M = {}
local query_processing = require("query-secretary.lib.query-processing")
local window = require("query-secretary.lib.window")
local lua_utils = require("query-secretary.lib.lua-utils")
local user_defaults = require("query-secretary.user.defaults")

---- Functions -----------------------------------------------------------

---@param win number
---@param _ number
---@param query_building_blocks query_building_block[]
local function _get_query_block_at_curor(win, _, query_building_blocks)
	local win_cur_line = vim.api.nvim_win_get_cursor(win)[1]
	for i, block in ipairs(query_building_blocks) do
		if block.tail and block.tail == win_cur_line then
			return block.lnum
		end
		if block.lnum == win_cur_line then
			return i
		end
	end
end

---@param win number
---@param buf number
---@param query_building_blocks query_building_block[]
---@param increment number
local function toggle_predicate_at_cursor(win, buf, query_building_blocks, increment)
	local default_predicates = user_defaults.predicates
	local block_index = _get_query_block_at_curor(win, buf, query_building_blocks)

	local current_predicate = query_building_blocks[block_index].predicate
	local predicate_index = lua_utils.tbl_index_of(default_predicates, current_predicate) or 0

	local new_predicate_index = lua_utils.increment_index({
		table = default_predicates,
		index = predicate_index,
		increment = increment,
		fallback = 1,
		decrement_fallback = true,
	})
	query_building_blocks[block_index].predicate = default_predicates[new_predicate_index]

	M.render_query_window(win, buf, query_building_blocks)
end

---@param win number
---@param buf number
---@param query_building_blocks query_building_block[]
---@param increment number
local function toggle_capture_group_name_at_cursor(win, buf, query_building_blocks, increment)
	local default_capture_group_names = user_defaults.capture_group_names
	local block_index = _get_query_block_at_curor(win, buf, query_building_blocks)

	local current_capture_group_name = query_building_blocks[block_index].capture_group_name
	local capture_group_index = lua_utils.tbl_index_of(default_capture_group_names, current_capture_group_name) or 0

	local new_predicate_index = lua_utils.increment_index({
		table = default_capture_group_names,
		index = capture_group_index,
		increment = increment,
		fallback = 1,
		decrement_fallback = true,
	})
	query_building_blocks[block_index].capture_group_name = default_capture_group_names[new_predicate_index]

	M.render_query_window(win, buf, query_building_blocks)
end

---removes predicate at cursor
---@param win number
---@param buf number
---@param query_building_blocks query_building_block[]
local function remove_predicate_at_cursor(win, buf, query_building_blocks)
	local block_index = _get_query_block_at_curor(win, buf, query_building_blocks)
	query_building_blocks[block_index].predicate = nil

	M.render_query_window(win, buf, query_building_blocks)
end

---toggle field_name at cursor
---@param win number
---@param buf number
---@param query_building_blocks query_building_block[]
local function toggle_field_name_at_cursor(win, buf, query_building_blocks)
	local block_index = _get_query_block_at_curor(win, buf, query_building_blocks)
	if query_building_blocks[block_index].display_field_name then
		query_building_blocks[block_index].display_field_name = nil
	else
		query_building_blocks[block_index].display_field_name = true
	end

	M.render_query_window(win, buf, query_building_blocks)
end

local query_window_augroup_name = "Query Secretary - Query Window"
pcall(vim.api.nvim_del_augroup_by_name, query_window_augroup_name) -- for hot reloading
local augroup = vim.api.nvim_create_augroup(query_window_augroup_name, {})
local oldBuf_namespace = vim.api.nvim_create_namespace("query_secretary__query_window")
---@param win number
---@param buf number
---@param query_building_blocks query_building_block[]
local function query_window_handle_autocmds(win, buf, query_building_blocks)
	vim.api.nvim_create_autocmd({ "CursorMoved" }, {
		buffer = buf,
		group = augroup,
		callback = function()
			local block_index = _get_query_block_at_curor(win, buf, query_building_blocks)
			vim.api.nvim_buf_clear_namespace(query_processing.oldBuf, oldBuf_namespace, 0, -1)

			local hl_group = user_defaults.visual_hl_group

			local start_row, start_col, end_row, end_col = query_building_blocks[block_index].node:range()
			vim.highlight.range(
				query_processing.oldBuf,
				oldBuf_namespace,
				hl_group,
				{ start_row, start_col },
				{ end_row, end_col },
				{ priority = 500 }
			)
		end,
	})

	vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
		buffer = buf,
		group = augroup,
		callback = function()
			vim.api.nvim_buf_clear_namespace(query_processing.oldBuf, oldBuf_namespace, 0, -1)
		end,
	})
end

local function set_key(modes, keys, callback, opts)
	if type(keys) == "string" then
		keys = { keys }
	end

	for _, key in ipairs(keys) do
		vim.keymap.set(modes, key, callback, opts)
	end
end

---@param win number
---@param buf number
---@param query_building_blocks query_building_block[]
local function query_window_handle_keymaps(win, buf, query_building_blocks)
	local keymaps = user_defaults.keymaps

	-- close query window
	set_key("n", keymaps.close, function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf })

	-- next / previous predicate at cursor
	set_key("n", keymaps.next_predicate, function()
		toggle_predicate_at_cursor(win, buf, query_building_blocks, 1)
	end, { buffer = buf })
	set_key("n", keymaps.previous_predicate, function()
		toggle_predicate_at_cursor(win, buf, query_building_blocks, -1)
	end, { buffer = buf })

	-- remove predicate at cursor
	set_key("n", keymaps.remove_predicate, function()
		remove_predicate_at_cursor(win, buf, query_building_blocks)
	end, { buffer = buf, nowait = true })

	-- toggle @capture_group name at cursor
	set_key("n", keymaps.next_capture_group, function()
		toggle_capture_group_name_at_cursor(win, buf, query_building_blocks, 1)
	end, { buffer = buf, nowait = true })
	set_key("n", keymaps.previous_capture_group, function()
		toggle_capture_group_name_at_cursor(win, buf, query_building_blocks, -1)
	end, { buffer = buf, nowait = true })

	-- toggle field_name at cursor
	set_key("n", keymaps.toggle_field_name, function()
		toggle_field_name_at_cursor(win, buf, query_building_blocks)
	end, { buffer = buf, nowait = true })

	-- yank entire query window, then close it
	set_key("n", keymaps.yank_query, function()
		vim.cmd(":% y")
		vim.api.nvim_win_close(win, true)
		vim.notify("query yanked")
	end, { buffer = buf, nowait = true })
end

---@param win number
---@param buf number
---@param query_building_blocks query_building_block[]
M.render_query_window = function(win, buf, query_building_blocks)
	-- get query window lines {} from query_building_blocks
	local lines_tbl = query_processing.query_building_blocks_2_buffer_lines(query_building_blocks)

	-- make query window's buffer modifiable
	window.toggle_buffer_modifiable(buf, true)

	-- handle query window's autocmds
	query_window_handle_autocmds(win, buf, query_building_blocks)

	-- set query window text with lines_tbl
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines_tbl)

	-- disable modifiable for query window's buffer
	window.toggle_buffer_modifiable(buf, false)
end

---Initiate Query Window
---@return number: winnr
---@return number: bufnr
M.query_window_initiate = function()
	-- gather_query_building_blocks
	local query_building_blocks = query_processing.gather_query_building_blocks()

	-- open empty window with specified options
	local win, buf = window.open_center_window({
		open_win_opts = user_defaults.open_win_opts,
		buf_set_opts = user_defaults.buf_set_opts,
	})

	-- render results to floating window
	M.render_query_window(win, buf, query_building_blocks)

	-- add mappings to floating window
	query_window_handle_keymaps(win, buf, query_building_blocks)

	-- jump to last line of query window after opening it
	vim.cmd(":norm! G")

	return win, buf
end

return M
