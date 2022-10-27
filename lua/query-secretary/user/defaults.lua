local M = {}

M.capture_group_names = { "cap", "second", "third" }
M.predicates = { "eq", "any-of", "contains", "match", "lua-match" }
M.visual_hl_group = "Visual"

M.open_win_opts = {
	relative = "editor",
	width = 80,
	height = 15,
}
M.buf_set_opts = {
	filetype = "query",
	tabstop = 2,
	softtabstop = 2,
	shiftwidth = 2,
}

M.setup = function(opts)
	for key, value in pairs(opts) do
		if key == "open_win_opts" or key == "buf_set_opts" then
			M[key] = vim.tbl_extend("force", M[key], value)
		else
			M[key] = value
		end
	end
end

return M
