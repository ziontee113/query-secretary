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

---if *index + increment <= #tbl*, returns `index + increment`
---otherwise returns `1`
---@param tbl table
---@param index integer
---@param increment integer
---@return number
M.increment_index_or_index_1 = function(tbl, index, increment)
	if index + increment <= #tbl then
		return index + increment
	else
		return 1
	end
end

return M
