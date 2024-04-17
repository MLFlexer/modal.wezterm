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

---@param name string
---@param key_table key_table
---@param color string
local function add_mode(name, key_table, color)
	table.insert(modes, { name = name, key_table = key_table, color = color })
end

---@param window any
---@param formatter? fun(mode: mode): string
local function get_mode_formatted(window, formatter)
	local mode = modes[get_mode(window)]
	if mode then
		local status

		-- checks if formatter is nil
		if formatter then
			status = formatter(mode)
		else
			status = wezterm.format({
				{ Foreground = { Color = mode.fg_color } },
				{ Background = { Color = mode.bg_color } },
				{ Text = wezterm.nerdfonts.ple_left_half_circle_thick },
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { Color = mode.bg_color } },
				{ Background = { Color = mode.fg_color } },
				{ Text = mode.name .. "  " },
			})
		end
		return status
	end
end

return {
	get_mode_formatted = get_mode_formatted,
	add_mode = add_mode,
	get_mode = get_mode,
}
