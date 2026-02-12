-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- plugins
local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')

-- This will hold the configuration.
local config = wezterm.config_builder()

local function get_appearance()
	if wezterm.gui then
		-- "Dark" or "Light" are typical return values, but check your OS if it fails
		return wezterm.gui.get_appearance()
	end
	-- Default to dark if wezterm.gui is not available
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		-- return "One Dark (Gogh)" -- Replace with your preferred dark theme
		-- return "OneDark (base16)" -- Replace with your preferred dark theme
		-- return "One Light (Gogh)" -- Replace with your preferred light theme
		return "Gruvbox Dark (Gogh)" -- Replace with your preferred dark theme
    -- return "Catppuccin Frappe"
    -- return "Catppuccin Latte"
	else
		-- return "One Light (Gogh)" -- Replace with your preferred light theme
		-- return "One Dark (base16)" -- Replace with your preferred light theme
		return "Gruvbox Dark (Gogh)" -- Replace with your preferred light theme
    -- return "Catppuccin Latte"
    -- return "Catppuccin Mocha"
    -- return "Catppuccin Frappe"
	end
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:

-- config.color_scheme = "Catppuccin Latte (Gogh)"
config.color_scheme = scheme_for_appearance(get_appearance())

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold", italic = false })
-- config.font = wezterm.font("ZedMono Nerd Font", { weight = 1000, italic = false })
-- config.font = wezterm.font("FiraCode Nerd Font Mono", { weight = 600, italic = false })
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
	{ key = "d", mods = "CMD|SHIFT", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "d", mods = "CMD", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "z", mods = "CMD", action = "TogglePaneZoomState" },
	{ key = "t", mods = "CMD", action = act({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "0", mods = "CMD", action = act.ShowDebugOverlay },
	{ key = "1", mods = "CMD", action = act({ ActivateTab = 0 }) },
	{ key = "2", mods = "CMD", action = act({ ActivateTab = 1 }) },
	{ key = "3", mods = "CMD", action = act({ ActivateTab = 2 }) },
	{ key = "4", mods = "CMD", action = act({ ActivateTab = 3 }) },
	{ key = "5", mods = "CMD", action = act({ ActivateTab = 4 }) },
	{ key = "p", mods = "CMD", action = act.ActivateCommandPalette },
	{ key = "[", mods = "CMD", action = act.ActivateCopyMode },
	{ key = "n", mods = "CMD", action = act.ToggleFullScreen },
	{ key = "v", mods = "CMD", action = act({ PasteFrom = "Clipboard" }) },
	{ key = "c", mods = "CMD", action = act({ CopyTo = "Clipboard" }) },

  -- move left and right
  -- { key = 'h', mods = 'ALT', action = act.SendKey({ key = 'LeftArrow', mods = 'ALT' }) },
  -- { key = 'j', mods = 'ALT', action = act.SendKey({ key = 'DownArrow', mods = 'ALT' }) },
  -- { key = 'k', mods = 'ALT', action = act.SendKey({ key = 'UpArrow', mods = 'ALT' }) },
  -- { key = 'l', mods = 'ALT', action = act.SendKey({ key = 'RightArrow', mods = 'ALT' }) },

	-- This is to be able to hit shift enter without executing commands.
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}

-- you can put the rest of your Wezterm config here
smart_splits.apply_to_config(config, {
  -- the default config is here, if you'd like to use the default keys,
  -- you can omit this configuration table parameter and just use
  -- smart_splits.apply_to_config(config)

  -- directional keys to use in order of: left, down, up, right
  direction_keys = { 'h', 'j', 'k', 'l' },
  -- if you want to use separate direction keys for move vs. resize, you
  -- can also do this:
  -- direction_keys = {
  --   move = { 'h', 'j', 'k', 'l' },
  --   resize = { 'LeftArrow', 'DownArrow', 'UpArrow', 'RightArrow' },
  -- },
  -- modifier keys to combine with direction_keys
  modifiers = {
    move = 'CTRL', -- modifier to use for pane movement, e.g. CTRL+h to move left
    resize = 'ALT', -- modifier to use for pane resize, e.g. META+h to resize to the left
  },
  -- log level to use: info, warn, error
  log_level = 'info',
})

-- and finally, return the configuration to wezterm
return config
