-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- 
-- parameters
-- 
local default_color = "#00B379"

----------------------------------------------------
-- Tab
----------------------------------------------------
config.window_decorations = "RESIZE"
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true

config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.window_background_gradient = {
	colors = { "#000000" },
}
config.show_new_tab_button_in_tab_bar = false
-- config.show_close_tab_button_in_tabs = false

config.colors = {
	tab_bar = {
	  inactive_tab_edge = "none",
	},
	compose_cursor = default_color,
	split = default_color,
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
 
	if tab.is_active then
	  background = default_color
	  foreground = "#FFFFFF"
	end
 
	local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
 
	return {
	  { Background = { Color = background } },
	  { Foreground = { Color = foreground } },
	  { Text = title },
	}
end)

-- 
-- Keybindings
-- 
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
  
-- 
-- hyperlink
-- 
-- config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- table.insert(config.hyperlink_rules, {
-- 	regex = [[\b[tt](\d+)\b]],
-- 	format = 'https://example.com/tasks/?t=$1',
-- })
-- table.insert(config.hyperlink_rules, {
-- 	regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
-- 	format = 'https://www.github.com/$1/$3',
-- })

-- 
-- leader
-- 
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

-- 
-- others
-- 
config.automatically_reload_config = true
config.use_ime = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20

config.adjust_window_size_when_changing_font_size = true

wezterm.on("window-config-reloaded", function(window, pane)
	wezterm.log_info("the config was reloaded for this window!")
end)

config.audible_bell = "Disabled"

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true

config.exit_behavior = "CloseOnCleanExit"

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 12
config.color_scheme = "Tokyo Night"
-- font = wezterm.font("JetBrains Mono")

config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400
-- Finally, return the configuration to wezterm:
return config
