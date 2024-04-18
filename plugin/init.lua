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

---Helper function to create formatted hints
---@param keys {text: string, bg: string, fg: string}
---@param hints {text: string, bg: string, fg: string}
---@param key_hint_seperator {text: string, bg: string, fg: string}
---@param left_seperator {text: string, bg: string, fg: string}
---@param mods? {text: string, bg: string, fg: string}
---@return string
local function create_hint(left_seperator, keys, key_hint_seperator, hints, mods)
	if mods then
		return wezterm.format({
			{ Foreground = { Color = left_seperator.fg } },
			{ Background = { Color = left_seperator.bg } },
			{ Text = left_seperator.text },
			{ Foreground = { Color = mods.fg } },
			{ Background = { Color = mods.bg } },
			{ Text = mods.text },
			{ Foreground = { Color = keys.fg } },
			{ Background = { Color = keys.bg } },
			{ Text = keys.text },
			{ Foreground = { Color = key_hint_seperator.fg } },
			{ Background = { Color = key_hint_seperator.bg } },
			{ Text = key_hint_seperator.text },
			{ Foreground = { Color = hints.fg } },
			{ Background = { Color = hints.bg } },
			{ Text = hints.text },
		})
	else
		return wezterm.format({
			{ Foreground = { Color = left_seperator.fg } },
			{ Background = { Color = left_seperator.bg } },
			{ Text = left_seperator.text },
			{ Foreground = { Color = keys.fg } },
			{ Background = { Color = keys.bg } },
			{ Text = keys.text },
			{ Foreground = { Color = key_hint_seperator.fg } },
			{ Background = { Color = key_hint_seperator.bg } },
			{ Text = key_hint_seperator.text },
			{ Foreground = { Color = hints.fg } },
			{ Background = { Color = hints.bg } },
			{ Text = hints.text },
		})
	end
end

return {
	get_mode_formatted = get_mode_formatted,
	add_mode = add_mode,
	get_mode = get_mode,
	get_hints_formatted = get_hints_formatted,
	add_formatted_hint = add_formatted_hint,
	create_hint = create_hint,
	modes = modes,
	key_tables = key_tables,
}
