local wezterm = require("wezterm")
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")

---Create status text with hints
---@param hint_icons {left_seperator: string, key_hint_seperator: string, mod_seperator: string}
---@param hint_colors {key_hint_seperator: string, key: string, hint: string, bg: string, left_bg: string}
---@param mode_colors {bg: string, fg: string}
---@return string
local function get_hint_status_text(hint_icons, hint_colors, mode_colors)
	return wezterm.format({
		{ Foreground = { Color = hint_colors.bg } },
		{ Background = { Color = hint_colors.left_bg } },
		{ Text = hint_icons.left_seperator },
		{ Background = { Color = hint_colors.bg } },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "CTRL" },
		{ Text = hint_icons.mod_seperator },
		{ Text = "p/n, 󰓢 : " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Prev/Next result" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "CTRL" },
		{ Text = hint_icons.mod_seperator },
		{ Text = "r: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Cycle match type" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "CTRL" },
		{ Text = hint_icons.mod_seperator },
		{ Text = "u: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Clear search" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "Enter: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Accep pattern" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "Esc: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "End search" },
		-- ...
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = mode_colors.bg } },
		{ Text = hint_icons.left_seperator },
		{ Foreground = { Color = mode_colors.fg } },
		{ Background = { Color = mode_colors.bg } },
		{ Text = "Search  " },
	})
end

---Create mode status text
---@param bg string
---@param fg string
---@param left_seperator string
---@return string
local function get_mode_status_text(left_seperator, bg, fg)
	return wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = bg } },
		{ Text = left_seperator },
		{ Foreground = { Color = fg } },
		{ Background = { Color = bg } },
		{ Text = "Search  " },
	})
end

return {
	get_mode_status_text = get_mode_status_text,
	get_hint_status_text = get_hint_status_text,
	key_table = {
		{
			key = "Enter",
			mods = "NONE",
			action = wezterm.action.Multiple({
				wezterm.action_callback(function(window, pane)
					wezterm.emit("modal.enter", "copy_mode", window, pane)
				end),
				wezterm.action.CopyMode("AcceptPattern"),
			}),
		},
		{
			key = "Escape",
			action = wezterm.action_callback(function(window, pane)
				wezterm.GLOBAL.search_mode = false
				window:perform_action(modal.exit_mode("search_mode"), pane)
				window:perform_action(modal.activate_mode("copy_mode"), pane)
			end),
		},
		{
			key = "c",
			mods = "CTRL",
			action = wezterm.action_callback(function(window, pane)
				wezterm.GLOBAL.search_mode = false
				window:perform_action(modal.exit_mode("search_mode"), pane)
				window:perform_action(modal.activate_mode("copy_mode"), pane)
			end),
		},
		{ key = "n", mods = "CTRL", action = wezterm.action.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = wezterm.action.CopyMode("PriorMatch") },
		{ key = "r", mods = "CTRL", action = wezterm.action.CopyMode("CycleMatchType") },
		{ key = "u", mods = "CTRL", action = wezterm.action.CopyMode("ClearPattern") },
		{
			key = "PageUp",
			mods = "NONE",
			action = wezterm.action.CopyMode("PriorMatchPage"),
		},
		{
			key = "PageDown",
			mods = "NONE",
			action = wezterm.action.CopyMode("NextMatchPage"),
		},
		{ key = "UpArrow", mods = "NONE", action = wezterm.action.CopyMode("PriorMatch") },
		{ key = "DownArrow", mods = "NONE", action = wezterm.action.CopyMode("NextMatch") },
	},
}
