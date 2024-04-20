local wezterm = require("wezterm")
local act = wezterm.action
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")

-- From smartsplits.nvim
local function is_vim(pane)
	-- this is set by the smart-splits.nvim plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local function activate_pane_direction(key, direction, mods, vim_mods)
	return {
		key = key,
		mods = mods,
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = vim_mods },
				}, pane)
			else
				win:perform_action({ ActivatePaneDirection = direction }, pane)
			end
		end),
	}
end

local function adjust_pane_size(key, direction, mods, vim_key, vim_mods, cells)
	return {
		key = key,
		mods = mods,
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = vim_key, mods = vim_mods },
				}, pane)
			else
				win:perform_action({ AdjustPaneSize = { direction, cells } }, pane)
			end
		end),
	}
end

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
		{ Text = "C?" },
		{ Text = hint_icons.mod_seperator },
		{ Text = "hjkl: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Go/resize" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "-: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Split" },
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
		{ Text = "r: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Rotate" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "q: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Close pane" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "t/T: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Open/Close tab" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "H/Tab, L/S-Tab: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Next/Prev tab" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "JK: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Move tab" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "n: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Rename tab" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "ALT" },
		{ Text = hint_icons.mod_seperator },
		{ Text = "t: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Tab nav" },
		{ Foreground = { Color = hint_colors.key_hint_seperator } },
		{ Text = hint_icons.key_hint_seperator },
		-- ...
		{ Foreground = { Color = hint_colors.key } },
		{ Text = "w/W: " },
		{ Foreground = { Color = hint_colors.hint } },
		{ Text = "Next/Prev Workspace " },
		-- ...
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = mode_colors.bg } },
		{ Text = hint_icons.left_seperator },
		{ Foreground = { Color = mode_colors.fg } },
		{ Background = { Color = mode_colors.bg } },
		{ Text = "UI  " },
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
		{ Text = "UI  " },
	})
end

return {
	get_mode_status_text = get_mode_status_text,
	get_hint_status_text = get_hint_status_text,
	key_table = {
		-- Cancel the mode by pressing escape
		{
			key = "Escape",
			action = modal.exit_mode("UI"),
		},
		{ key = "c", mods = "CTRL", action = modal.exit_mode("UI") },

		-- Activate panes
		activate_pane_direction("h", "Left", "", "CTRL"),
		activate_pane_direction("j", "Down", "", "CTRL"),
		activate_pane_direction("k", "Up", "", "CTRL"),
		activate_pane_direction("l", "Right", "", "CTRL"),

		-- Resize
		adjust_pane_size("h", "Left", "CTRL", "h", "CTRL|ALT", 1),
		adjust_pane_size("l", "Right", "CTRL", "l", "CTRL|ALT", 1),
		adjust_pane_size("k", "Up", "CTRL", "k", "CTRL|ALT", 1),
		adjust_pane_size("j", "Down", "CTRL", "j", "CTRL|ALT", 1),
		adjust_pane_size("LeftArrow", "Left", "", "h", "CTRL|ALT", 1),
		adjust_pane_size("RightArrow", "Right", "", "l", "CTRL|ALT", 1),
		adjust_pane_size("UpArrow", "Up", "", "k", "CTRL|ALT", 1),
		adjust_pane_size("DownArrow", "Down", "", "j", "CTRL|ALT", 1),

		-- Zoom toggle
		{ key = "z", action = wezterm.action.TogglePaneZoomState },

		-- Split pane
		{ key = "-", action = wezterm.action.SplitVertical },
		{ key = "_", mods = "SHIFT", action = wezterm.action.SplitHorizontal },

		-- Close pane
		{ key = "q", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

		-- Rotate panes
		{ key = "r", action = act.RotatePanes("Clockwise") },
		{ key = "R", action = act.RotatePanes("CounterClockwise") },

		-- Selecting
		{ key = "S", mods = "SHIFT", action = act.PaneSelect({}) },
		-- Swap
		{ key = "s", action = act.PaneSelect({ mode = "SwapWithActive" }) },

		-- Tabs
		{ key = "t", action = act.SpawnTab("CurrentPaneDomain") },
		{ key = "T", mods = "SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },

		{ key = "H", mods = "SHIFT", action = act.ActivateTabRelative(-1) },
		{ key = "L", mods = "SHIFT", action = act.ActivateTabRelative(1) },
		{ key = "Tab", mods = "", action = act.ActivateTabRelative(1) },
		{ key = "Tab", mods = "SHIFT", action = act.ActivateTabRelative(-1) },

		{ key = "J", mods = "SHIFT", action = act.MoveTabRelative(-1) },
		{ key = "K", mods = "SHIFT", action = act.MoveTabRelative(1) },

		{ key = "t", mods = "ALT", action = wezterm.action.ShowTabNavigator },

		{
			key = "n",
			action = act.Multiple({
				act.PopKeyTable,
				act.PromptInputLine({
					description = "Enter new name for tab",
					action = wezterm.action_callback(function(window, pane, name)
						if name then
							window:active_tab():set_title(name)
						end
						window:perform_action(
							act.ActivateKeyTable({
								name = "UI",
								one_shot = false,
							}),
							pane
						)
					end),
				}),
			}),
		},

		-- Workspace
		{ key = "w", action = act.SwitchWorkspaceRelative(1) },
		{ key = "W", mods = "SHIFT", action = act.SwitchWorkspaceRelative(-1) },

		-- New window
		{ key = "N", mods = "SHIFT", action = wezterm.action.SpawnWindow },
	},
}
