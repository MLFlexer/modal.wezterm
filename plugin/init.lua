local wezterm = require("wezterm")

-- see https://wezfurlong.org/wezterm/config/lua/keyassignment/index.html
---@alias KeyAssignment any

---@alias key_bind {key: string, mods: string|nil, action: any}
---@alias key_table key_bind[]
---@alias mode { name: string, key_table_name: string, status_text: string | nil}

-- map from key_table_name to mode
---@type table<string, mode>
local modes = {
	copy_mode = { name = "copy_mode", key_table_name = "copy_mode", status_text = "Copy" },
	search_mode = { name = "search_mode", key_table_name = "search_mode", status_text = "Search" },
}

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
---@param key_table {key: string, mods: string|nil, action: any}[]
---@param key_table_name? string
---@param status_text? string
local function add_mode(name, key_table, status_text, key_table_name)
	if name == "copy_mode" or name == "search_mode" then
		modes[name].status_text = status_text
		return
	end
	if key_table_name then
		modes[key_table_name] = { name = name, key_table_name = key_table_name, status_text = status_text }
		key_tables[key_table_name] = key_table
	else
		modes[name] = { name = name, key_table_name = name, status_text = status_text }
		key_tables[name] = key_table
	end
end

---Wrapper for creating a simple status text
---@param left_seperator {text: string, bg: string, fg: string}
---@param key_hints {text: string, bg: string, fg: string}
---@param mode {text: string, bg: string, fg: string}
---@return string
local function create_status_text(left_seperator, key_hints, mode)
	return wezterm.format({
		{ Foreground = { Color = left_seperator.fg } },
		{ Background = { Color = left_seperator.bg } },
		{ Text = left_seperator.text },
		{ Foreground = { Color = key_hints.fg } },
		{ Background = { Color = key_hints.bg } },
		{ Text = key_hints.text },
		{ Foreground = { Color = mode.bg } },
		{ Background = { Color = key_hints.bg } },
		{ Text = left_seperator.text },
		{ Foreground = { Color = mode.fg } },
		{ Background = { Color = mode.bg } },
		{ Text = mode.text },
	})
end

local function enable_defaults(url)
	local plugin
	for _, p in ipairs(wezterm.plugin.list()) do
		if p.url == url then
			plugin = p
			break
		end
	end
	package.path = package.path .. ";" .. plugin.plugin_dir .. "/defaults/?.lua"
end

---sets the current modal status to the right status
---@param window any
---@param name? string
local function set_right_status(window, name)
	if name then
		local mode = modes[name]
		window:set_right_status(mode.status_text)
	else
		local mode = get_mode(window)
		if mode then
			window:set_right_status(mode.status_text)
		end
	end
end

---Activates mode
---@param name string
---@param activate_key_table_params? table -- parameters as defined here: https://wezfurlong.org/wezterm/config/lua/keyassignment/ActivateKeyTable.html
---@return KeyAssignment
local function activate_mode(name, activate_key_table_params)
	if name == "copy_mode" then
		return wezterm.action.Multiple({
			wezterm.action.ActivateCopyMode,
			wezterm.action_callback(function(window, pane)
				wezterm.emit("modal.enter", name, window, pane)
			end),
		})
	elseif name == "search_mode" then
		return wezterm.action.Multiple({
			wezterm.action.Search({ CaseSensitiveString = "" }),
			wezterm.action_callback(function(window, pane)
				wezterm.emit("modal.enter", name, window, pane)
			end),
		})
	else
		local parameters = activate_key_table_params or { one_shot = false }
		parameters.name = name

		return wezterm.action.Multiple({
			wezterm.action.ActivateKeyTable(parameters),
			wezterm.action_callback(function(window, pane)
				wezterm.emit("modal.enter", name, window, pane)
			end),
		})
	end
end

---Exits active mode
---@param name string
---@return KeyAssignment
local function exit_mode(name)
	return wezterm.action.Multiple({
		wezterm.action.PopKeyTable(),
		wezterm.action_callback(function(window, pane)
			wezterm.emit("modal.exit", name, window, pane)
		end),
	})
end

---Exits all active modes
---@param name string
---@return KeyAssignment
local function exit_all_modes(name)
	return wezterm.action.Multiple({
		wezterm.action.ClearKeyTableStack(),
		wezterm.action_callback(function(window, pane)
			wezterm.emit("modal.exit_all", name, window, pane)
		end),
	})
end

local function apply_to_config(config)
	enable_defaults("https://github.com/MLFlexer/modal.wezterm")
	local icons = {
		left_seperator = wezterm.nerdfonts.ple_left_half_circle_thick,
		key_hint_seperator = "  ",
		mod_seperator = "-",
	}
	local colors = {
		key_hint_seperator = config.colors.tab_bar.active_tab.fg_color,
		key = config.colors.tab_bar.active_tab.fg_color,
		hint = config.colors.tab_bar.active_tab.fg_color,
		bg = config.colors.tab_bar.active_tab.bg_color,
		left_bg = config.colors.tab_bar.background,
	}

	local status_text = require("ui_mode").get_hint_status_text(
		icons,
		colors,
		{ bg = config.colors.ansi[2], fg = config.colors.tab_bar.active_tab.bg_color }
	)

	add_mode("UI", require("ui_mode").key_table, status_text)

	status_text = require("scroll_mode").get_hint_status_text(
		icons,
		colors,
		{ bg = config.colors.ansi[7], fg = config.colors.tab_bar.active_tab.bg_color }
	)
	add_mode("Scroll", require("scroll_mode").key_table, status_text)

	status_text = require("copy_mode").get_hint_status_text(
		icons,
		colors,
		{ bg = config.colors.ansi[4], fg = config.colors.tab_bar.active_tab.bg_color }
	)
	add_mode("copy_mode", {}, status_text)

	status_text = require("search_mode").get_hint_status_text(
		icons,
		colors,
		{ bg = config.colors.ansi[6], fg = config.colors.tab_bar.active_tab.bg_color }
	)
	add_mode("search_mode", {}, status_text)

	config.key_tables = key_tables
	table.insert(config.keys, {
		key = "n",
		mods = "ALT",
		action = activate_mode("Scroll"),
	})
	table.insert(config.keys, {
		key = "u",
		mods = "ALT",
		action = activate_mode("UI"),
	})
end

return {
	set_right_status = set_right_status,
	add_mode = add_mode,
	get_mode = get_mode,
	create_status_text = create_status_text,
	modes = modes,
	key_tables = key_tables,
	enable_defaults = enable_defaults,
	apply_to_config = apply_to_config,
	activate_mode = activate_mode,
	exit_mode = exit_mode,
	exit_all_modes = exit_all_modes,
}
