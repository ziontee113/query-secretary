local M = {}

---returns `index` of *value* in *tbl*
---@param tbl table
---@param value any
---@return integer|nil
M.tbl_index_of = function(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then
			return i
		end
	end
end

---@class increment_index_opts
---@field table table
---@field index number
---@field increment number
---@field fallback any

---if *index + increment <= #tbl*, returns `index + increment`
---otherwise returns `fallback`
---@param opts increment_index_opts
M.increment_index = function(opts)
	if opts.index + opts.increment <= #opts.table then
		return opts.index + opts.increment
	else
		return opts.fallback
	end
end

return M
