# modal.wezterm
Vim-like modal keybindings for your terminal! ✌️

## Overview
Add keybindings which operate with vim-like modal bindings to accelerate your workflow.
This plugin adds great opt-in default modes along with optional visual indicators and hints for the keybindings.

#### Default Copy/Visual/Search mode
Improvements to [Wezterms CopyMode](https://wezfurlong.org/wezterm/copymode.html) with vim keybindings
![Demo of Copy/Search/Visual mode](https://github.com/MLFlexer/modal.wezterm/assets/75012728/08c2af5c-c75a-4764-bd63-729a91080f79)



#### Default UI mode

![Demo of UI mode](https://github.com/MLFlexer/modal.wezterm/assets/75012728/84e5860a-5659-43d9-af51-bb2942b005a6)

## Default modes
I have included some default modes which are opt-in as to improve performance for all users.

### Copy mode, with Search and Visual submodes
![Copy mode](https://github.com/MLFlexer/modal.wezterm/assets/75012728/d11d088c-f99a-464f-8de6-2a447da1e57a)
![Visual mode](https://github.com/MLFlexer/modal.wezterm/assets/75012728/b8c63098-f8e3-481e-8881-b617d6b87a80)
![Search mode](https://github.com/MLFlexer/modal.wezterm/assets/75012728/ee8a9881-2c7f-499f-ba66-f55f81360869)

### UI mode
UI mode has vim-like bindings to navigate and modify panes, tabs and other UI elements.
![UI mode](https://github.com/MLFlexer/modal.wezterm/assets/75012728/07545d3d-2f94-44df-8f02-cb9ff0ee6d0a)

### Scroll mode
In scroll mode you can scroll with familiar vim bindings.
![Scroll mode](https://github.com/MLFlexer/modal.wezterm/assets/75012728/52e792dd-580d-4bea-a31f-e5f589212217)

## Setup
It is recommended to do the setup with some [Customization](#Customization). However if you just want to try it out you can follow the [Preset](#Preset)
### Preset
Add the following to the bottom of your config:
```lua
local wezterm = require("wezterm")
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
modal.apply_to_config(config)
```
This will add the keybindings to enter and exit modes:
* `ALT-u` to enter UI mode from normal mode
* `ALT-c` to enter Copy mode from normal mode
* `v` to enter visual mode from Copy mode
* `/` to enter search mode from Copy mode
* `ALT-n` to enter Scroll mode from normal mode
* `esc` or `CTRL-c` to leave current non-normal mode

Checkout the [keybinding descriptions](/defaults/keybinds.md)

### Customization
1. Require the plugin:
```lua
local wezterm = require("wezterm")
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
```
2. Add your own mode

*There are more examples of key tables and status texts with and without hints in the `/defaults` directory.*
```lua
-- example key table
local key_table = {
  { key = "Escape", action = modal.exit_mode("mode_name") },
  { key = "c", mods = "CTRL", action = modal.exit_mode("mode_name") },
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
    action = activate_mode("mode_name"),
  }
}
```
4. Add the modes to your config
```lua
config.key_tables = modal.key_tables
```
5. Change right status text when entering/leaving mode
```lua
wezterm.on("update-right-status", function(window, _)
  modal.set_right_status(window)
end)
```

## Configuration
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
    action = activate_mode("UI"),
  }
}
config.key_tables = modal.key_tables
```
Checkout the specific lua files to see the keybindings and what functionality each mode exports

### Adding custom right status text
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
You should then add the text to your right status by following the steps in the next paragraph
### Update right status on mode change
#### *Recommended:* Using enter and exit events
You can use the `modal.enter` and `modal.exit` events to set the right status:
```lua
wezterm.on("modal.enter", function(name, window, pane)
  modal.set_right_status(window, name)
  modal.set_window_title(pane, name)
end)

wezterm.on("modal.exit", function(name, window, pane)
  window:set_right_status("NOT IN A MODE")
  modal.reset_window_title(pane)
end)
```
#### Using the wezterm.on("update-right-status", ...) event
Alternatively you can show some other text in the right status by making a simple if statement in your `wezterm.on` function:
```lua
wezterm.on("update-right-status", function(window, _)
  if modal.get_mode(window) then -- is nil if you are not in a mode
    modal.set_right_status(window)
  else
    -- your other status
  end
end)
```

## Credits
Thanks to [github.com/twilsoft/wezmode](https://github.com/twilsoft/wezmode) for the inspiration to make this plugin. I have created this plugin as a lua alternative to wezmode, as I wanted to extend wezmode, but with lua instead of typescript.
