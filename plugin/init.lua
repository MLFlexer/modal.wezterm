local wezterm = require("wezterm")

---@alias key_bind {key: string, mods: string|nil, action: any}
---@alias key_table key_bind[]
---@alias mode { name: string, key_table_name: string, hint: string | nil, fg_color: string, bg_color: string}

-- map from key_table_name to mode
---@type table<string, mode>
local modes = {}

-- map from key_table_name to key_table
---@type table<string, key_table>
local key_tables = {}

---@param window any
---@return mode | nil
local function get_mode(window)
	local active_key_table = window:active_key_table()

	if active_key_table then
		return modes[active_key_table]
	end
end

---@param name string
---@param key_table key_table
---@param fg_color string
---@param bg_color string
---@param key_table_name? string
local function add_mode(name, key_table, fg_color, bg_color, key_table_name)
	if key_table_name then
		modes[key_table_name] =
			{ name = name, key_table_name = key_table_name, fg_color = fg_color, bg_color = bg_color }
		key_tables[key_table_name] = key_table
	else
		modes[name] = { name = name, key_table_name = name, fg_color = fg_color, bg_color = bg_color }
		key_tables[name] = key_table
	end
end

---@param window any
---@param formatter? fun(mode: mode): string
local function get_mode_formatted(window, formatter)
	local mode = get_mode(window)
	if mode == nil then
		return ""
	end

	local status

	-- checks if formatter is nil
	if formatter then
		status = formatter(mode)
	else
		status = wezterm.format({
			{ Foreground = { Color = mode.fg_color } },
			{ Text = wezterm.nerdfonts.ple_left_half_circle_thick },
			{ Attribute = { Intensity = "Bold" } },
			{ Foreground = { Color = mode.bg_color } },
			{ Background = { Color = mode.fg_color } },
			{ Text = mode.name .. "  " },
		})
	end
	return status
end

---adds a formatted hint string to the mode
---@param name string
---@param formatted_hint string
local function add_formatted_hint(name, formatted_hint)
	modes[name].hint = formatted_hint
end

---returns a string of any hints
---@param window any
---@return string
local function get_hints_formatted(window)
	local mode = get_mode(window)
	if mode == nil then
		return ""
	end

	return mode.hint
end
return {
	get_mode_formatted = get_mode_formatted,
	add_mode = add_mode,
	get_mode = get_mode,
	modes = modes,
	key_tables = key_tables,
}
