local wezterm = require("wezterm")

---@alias key_bind {key: string, mods: string|nil, action: any}
---@alias key_table key_bind[]
--- @alias mode { name: string, key_table: key_table, hint: string | nil, bg_color: string, fg_color: string}

--- @type table<string, mode>
local modes = {}

---@param window any
---@return string
local function get_mode(window)
	local active_key_table = window:active_key_table()
	return active_key_table.name
end
---@param window any
