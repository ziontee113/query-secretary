local M = {}
local query_processing = require("query-secretary.lib.query-processing")
local window = require("query-secretary.lib.window")

M.query_window_initiate = function()
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

	return win, buf
end

M.add_predicate = function()
	-- TODO: create mappings handling first to call this method
end

return M
