local M = {}

---open floating window at the center of the editor
---@param open_win_opts table
---@param win_set_opts table | nil
M.open_center_window = function(open_win_opts, win_set_opts)
	local buf, win

	-- buf options
	buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf, "filetype", "query")
	vim.api.nvim_buf_set_option(buf, "bufhidden", "delete")

	-- get editorStats
	local editorStats = vim.api.nvim_list_uis()[1]
	local editorWidth = editorStats.width
	local editorHeight = editorStats.height

	-- handle open_win_opts
	local default_width, default_height = 24, 10
	local default_opts = {
		relative = "editor",
		col = math.ceil((editorWidth - (open_win_opts.width or default_width)) / 2),
		row = math.ceil((editorHeight - (open_win_opts.height or default_height)) / 2) - 1,
		style = "minimal",
		border = "single",
		width = default_width,
		height = default_height,
	}
	open_win_opts = vim.tbl_extend("force", default_opts, open_win_opts)

	-- open window with open_win_opts
	win = vim.api.nvim_open_win(buf, true, open_win_opts)

	-- handle win_set_opts
	local default_win_set_opts = {
		winhl = "NormalFloat:",
		cursorline = true,
	}
	win_set_opts = vim.tbl_extend("force", default_win_set_opts, win_set_opts or {})
	for key, value in pairs(win_set_opts) do
		vim.api.nvim_win_set_option(win, key, value)
	end
end

return M
