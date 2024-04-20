local wezterm = require("wezterm")
local act = wezterm.action
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
		{ Text = "Shift?" },
		{ Text = hint_icons.mod_seperator },
		{ Text = "jk: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Line scroll" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "Shift?" },
		{ Text = hint_icons.mod_seperator },
		{ Text = "d/u: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Page scroll" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "{/}, p/n: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Prev/Next prompt" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "g/G: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "top/bottom" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "z: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Zoom" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "v: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Copy mode " },
		-- ...
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = mode_colors.bg } },
		{ Text = hint_icons.left_seperator },
		{ Foreground = { Color = mode_colors.fg } },
		{ Background = { Color = mode_colors.bg } },
		{ Text = "Scroll  " },
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
		{ Text = "Scroll  " },
	})
end

return {
	get_mode_status_text = get_mode_status_text,
	get_hint_status_text = get_hint_status_text,
	key_table = {
		-- Cancel the mode by pressing escape
		{ key = "Escape", action = modal.exit_mode("Scroll") },
		{ key = "c", mods = "CTRL", action = modal.exit_mode("Scroll") },

		{ key = "UpArrow", action = act.ScrollByLine(-1) },
		{ key = "DownArrow", action = act.ScrollByLine(1) },
		{ key = "k", action = act.ScrollByLine(-1) },
		{ key = "j", action = act.ScrollByLine(1) },

		{ key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-5) },
		{ key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(5) },
		{ key = "K", mods = "SHIFT", action = act.ScrollByLine(-5) },
		{ key = "J", mods = "SHIFT", action = act.ScrollByLine(5) },

		{ key = "u", action = act.ScrollByPage(-0.5) },
		{ key = "d", action = act.ScrollByPage(0.5) },
		{ key = "U", mods = "SHIFT", action = act.ScrollByPage(-1) },
		{ key = "D", mods = "SHIFT", action = act.ScrollByPage(1) },

		{ key = "p", action = act.ScrollToPrompt(-1) },
		{ key = "n", action = act.ScrollToPrompt(1) },
		{ key = "{", action = act.ScrollToPrompt(-1) },
		{ key = "}", action = act.ScrollToPrompt(1) },

		{ key = "g", action = act.ScrollToTop },
		{ key = "G", mods = "SHIFT", action = act.ScrollToBottom },

		{ key = "z", action = wezterm.action.TogglePaneZoomState },

		{ key = "v", action = modal.activate_mode("copy_mode") },
		{ key = "/", action = modal.activate_mode("search_mode") },
	},
}
