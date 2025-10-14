-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "Catppuccin Latte (Gogh)"
config.color_scheme = "Gruvbox Dark (Gogh)"

-- config.font = wezterm.font("FiraCode Nerd Font", { weight = "Bold", italic = false })
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold", italic = false })
-- config.font = wezterm.font("Hasklig", { weight = "Bold", italic = false })
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- no audible bell
config.audible_bell = "Disabled"

config.font_size = 14
config.hide_tab_bar_if_only_one_tab = true
config.term = "xterm-256color"

-- Keybindings
config.disable_default_key_bindings = true

-- Option key behavior
-- To make the left Option key behave like a standard Alt key, set this to false.
config.send_composed_key_when_left_alt_is_pressed = false

config.keys = {
	{ key = "-", mods = "CMD", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "\\", mods = "CMD", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "z", mods = "CMD", action = "TogglePaneZoomState" },
	{ key = "t", mods = "CMD", action = act({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "h", mods = "CMD", action = act({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "CMD", action = act({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "CMD", action = act({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "CMD", action = act({ ActivatePaneDirection = "Right" }) },
	{ key = "0", mods = "CMD", action = act.ShowDebugOverlay },
	{ key = "1", mods = "CMD", action = act({ ActivateTab = 0 }) },
	{ key = "2", mods = "CMD", action = act({ ActivateTab = 1 }) },
	{ key = "3", mods = "CMD", action = act({ ActivateTab = 2 }) },
	{ key = "4", mods = "CMD", action = act({ ActivateTab = 3 }) },
	{ key = "5", mods = "CMD", action = act({ ActivateTab = 4 }) },
	{ key = "p", mods = "CMD|SHIFT", action = act.ActivateCommandPalette },
	{ key = "[", mods = "CMD", action = act.ActivateCopyMode },
	{ key = "v", mods = "CMD", action = act({ PasteFrom = "Clipboard" }) },
	{ key = "c", mods = "CMD", action = act({ CopyTo = "Clipboard" }) },
}

-- and finally, return the configuration to wezterm
return config
