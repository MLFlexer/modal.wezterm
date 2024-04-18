-- NOTE: This file is used to make status text for Wezterms buildin search mode
local wezterm = require("wezterm")

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
		{ Text = "Prev result" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "Esc: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Exit mode " },
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
}
