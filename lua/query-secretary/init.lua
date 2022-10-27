local M = {}
local business__query_window = require("query-secretary.business.query-window")
local user_default = require("query-secretary.user.defaults")

-- TODO: implement our own ts_utils.get_node_at_cursor(), since it doesn't work with comments

-- TODO: implement SIBLINGS
-- TODO: implement CHILDREN
-- TODO: implement UNNAMED NODES

M.query_window_initiate = business__query_window.query_window_initiate

M.setup = user_default.setup

return M
