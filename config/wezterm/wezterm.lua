-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- 
-- parameters
-- 
local active_bg_color = "#00B379"
local inactive_bg_color = "#5c6d74"
local font_color = "#FFFFFF"

local mux = wezterm.mux
local HOME = os.getenv("HOME")

----------------------------------------------------
-- Tab
----------------------------------------------------
config.window_decorations = "RESIZE"
config.show_tabs_in_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
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
	compose_cursor = active_bg_color,
	split = active_bg_color,
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = inactive_bg_color
	local foreground = font_color
 
	if tab.is_active then
	  background = active_bg_color
	  foreground = font_color
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
-- leader
-- 
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

-- 
-- workspace
-- 

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
