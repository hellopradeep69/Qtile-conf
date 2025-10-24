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

	-- Custom red-themed tab bar colors
	colors = {
		tab_bar = {
			background = "#1a0d0d", -- Background behind all tabs

			active_tab = {
				bg_color = "#cc4444", -- Bright red for the active tab
				fg_color = "#1a0d0d", -- Dark text for contrast
				intensity = "Bold",
				underline = "None",
				italic = false,
			},

			inactive_tab = {
				bg_color = "#3b1f1f", -- Dull red-brown for inactive tabs
				fg_color = "#f0c0c0", -- Soft pink text
			},

			inactive_tab_hover = {
				bg_color = "#5a2a2a", -- Slightly brighter on hover
				fg_color = "#ffffff",
				italic = true,
			},

			new_tab = {
				bg_color = "#1a0d0d",
				fg_color = "#ff6b6b", -- Reddish-pink icon for new tab
			},

			new_tab_hover = {
				bg_color = "#3b1f1f",
				fg_color = "#ff9999",
				italic = true,
			},
		},
	},

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
	},
}
