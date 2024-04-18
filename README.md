# modal.wezterm
Vim-like modal keybindings for your terminal! ✌️

![demo of UI mode](https://github.com/MLFlexer/modal.wezterm/assets/75012728/84e5860a-5659-43d9-af51-bb2942b005a6)


## Setup
1. Require the plugin:
```lua
local wezterm = require("wezterm")
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
```
2. Add your mode
```lua
-- example key table
local key_table = {
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "c", mods = "CTRL", action = "PopKeyTable" },
		{ key = "z", action = wezterm.action.TogglePaneZoomState },
  }
-- example right status text
local status_text = wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Foreground = { Color = "Red" } },
		{ Text = wezterm.nerdfonts.ple_left_half_circle_thick },
		{ Foreground = { Color = "Black" } },
		{ Background = { Color = "Red" } },
		{ Text = "MODE NAME  " },
	})
modal.add_mode("mode_name", key_table, status_text)
```
3. Add you keybind to enter the mode
```lua
config.keys = {
  -- ...
  -- your other keybindings
  {
		key = "m",
		mods = "ALT",
		action = act.ActivateKeyTable({
			name = "mode_name",
			one_shot = false,
		}),
  }
}
```
4. Change right status text when entering/leaving mode
```lua
wezterm.on("update-right-status", function(window, _)
	modal.set_right_status(window)
end)
```

## Default modes
I have included some default modes which are opt-in as to improve performance for all users.

### Enabling default modes
If you want to enable a default mode, then you can add the following:
```lua
modal.enable_defaults("https://github.com/MLFlexer/modal.wezterm")
-- "ui_mode" can be replaced by any filename from the /defaults directory
local key_table = require("ui_mode").key_table

local icons = {
	left_seperator = wezterm.nerdfonts.ple_left_half_circle_thick,
	key_hint_seperator = " | ",
	mod_seperator = "-",
}
local hint_colors = {
	key_hint_seperator = "Yellow",
	key = "Green",
	hint = "Red",
	bg = "Black",
	left_bg = "Gray",
}
local mode_colors = { bg = "Red", fg = "Black" }
local status_text = require("ui_mode").get_hint_status_text(icons, hint_colors, mode_colors)

modal.add_mode("UI", key_table, status_text)

config.keys = {
  -- ...
  -- your other keybindings
  {
		key = "u",
		mods = "ALT",
		action = act.ActivateKeyTable({
			name = "UI",
			one_shot = false,
		}),
  }
}
```
Checkout the specific lua files to see the keybindings and what functionality each mode exports

## Configuration
### Adding custom right status
To add a custom right status you can use the [wezterm.format()](https://wezfurlong.org/wezterm/config/lua/wezterm/format.html) function to create a formatted string. You can then add it as an argument when you add your mode:
```lua
local custom_status = wezterm.format({
	{ Attribute = { Intensity = "Bold" } },
	{ Foreground = { Color = bg } },
	{ Text = wezterm.nerdfonts.ple_left_half_circle_thick },
	{ Foreground = { Color = fg } },
	{ Background = { Color = bg } },
	{ Text = "Some custom text  " },
})
modal.add_mode("mode_name", key_table, custom_status)
```

### Show other text than only modes in right status
You can show some other text in the right status by making a simple if statement in your `wezterm.on` function:
```lua
wezterm.on("update-right-status", function(window, _)
	if modal.get_mode(window) then -- is nil if you are not in a mode
		modal.set_right_status(window)
	else
    -- your other status
	end
end)
```
