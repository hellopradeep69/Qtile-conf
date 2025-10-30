-- Load wezterm API
local wezterm = require("wezterm")

-- Main configuration table
return {
	-- Choose a color scheme (uncomment one to use it)
	-- color_scheme = "Catppuccin Mocha",
	-- color_scheme = "Tomorrow Night",
	-- color_scheme = "Gruvbox Dark (Gogh)",
	color_scheme = "GruvboxDarkHard",
	-- color_scheme = "Dracula",
	-- color_scheme = "Tokyo Night Storm",

	-- Cursor appearance settings
	animation_fps = 60, -- Smooth cursor animation
	default_cursor_style = "SteadyBlock",

	-- Font settings
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" }),
	font_size = 12.0,

	-- Tab bar behavior and appearance
	enable_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = false,
	tab_max_width = 16,
	show_tab_index_in_tab_bar = true,
	tab_bar_at_bottom = true,
	show_new_tab_button_in_tab_bar = false,

	-- Window appearance
	window_decorations = "RESIZE", -- Only border, no title bar

	-- Optional: Window padding for better spacing (currently commented out)
	-- window_padding = {
	--   left = 4,
	--   right = 4,
	--   top = 2,
	--   bottom = 2,
	-- },

	-- Dim inactive panes (useful in split layouts)
	inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.8,
	},

	-- Terminal bell behavior
	audible_bell = "SystemBeep", -- Options: "SystemBeep", "VisualBell", "Disabled"

	-- Custom key bindings
	keys = {
		-- Ctrl+C to copy to clipboard
		{
			key = "c",
			mods = "CTRL",
			action = wezterm.action.CopyTo("Clipboard"),
		},

		-- Ctrl+V to paste from clipboard
		{
			key = "v",
			mods = "CTRL",
			action = wezterm.action.PasteFrom("Clipboard"),
		},

		-- Ctrl+Shift+C to send Ctrl+C (interrupt signal)
		{
			key = "c",
			mods = "CTRL|SHIFT",
			action = wezterm.action.SendKey({
				key = "c",
				mods = "CTRL",
			}),
		},
		-- ctrl J to send ctrl c
		-- {
		-- 	key = "j",
		-- 	mods = "CTRL",
		-- 	action = wezterm.action.SendKey({
		-- 		key = "c",
		-- 		mods = "CTRL",
		-- 	}),
		-- },
	},
}
