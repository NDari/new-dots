-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

-- plugins
local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')

-- This will hold the configuration.
local config = wezterm.config_builder()

-- utility for configs changings based on OS
-- local is_windows = function()
-- 	return wezterm.target_triple:find("windows") ~= nil
-- end

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
		return "Gruvbox Dark (Gogh)" -- Replace with your preferred dark theme
    -- return "Catppuccin Frappe"
	else
		-- return "One Light (base16)" -- Replace with your preferred light theme
		-- return "One Light (Gogh)" -- Replace with your preferred light theme
		return "Gruvbox Dark (Gogh)" -- Replace with your preferred light theme
    -- return "Catppuccin Latte"
    -- return "Catppuccin Mocha"
	end
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local s = f:read("*l")
  f:close()
  return s
end

local scheme = read_file(os.getenv("HOME") .. "/.local/share/tinted-theming/tinty/artifacts/current_scheme")
-- The config for wezterm
config.color_scheme = scheme or scheme_for_appearance(get_appearance())

-- This is where you actually apply your config choices

-- config.color_scheme = "Catppuccin Latte (Gogh)"
-- config.color_scheme = scheme_for_appearance(get_appearance())

-- config.font = wezterm.font("JetBrainsMonoNL Nerd Font", { weight = 600, italic = false })
-- config.font = wezterm.font("ZedMono Nerd Font", { weight = 1000, italic = false })
-- config.font = wezterm.font("FiraCode Nerd Font Mono", { weight = 500, italic = false })
config.font = wezterm.font("SauceCodePro Nerd Font Mono", { weight = "Bold", italic = true })
-- config.font = wezterm.font("Hasklig", { weight = "Bold", italic = false })
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

-- no audible bell
config.audible_bell = "Disabled"

config.font_size = 12
config.hide_tab_bar_if_only_one_tab = true
config.term = "xterm-256color"

-- Keybindings
config.disable_default_key_bindings = true

config.leader = { key = "s", mods = "ALT" }
config.keys = {
	{ key = "-", mods = "LEADER", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "\\", mods = "LEADER", action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = act({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = act({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = act({ ActivatePaneDirection = "Right" }) },
	{ key = "0", mods = "LEADER", action = act.ShowDebugOverlay },
	{ key = "1", mods = "LEADER", action = act({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = act({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = act({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = act({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = act({ ActivateTab = 4 }) },
	{ key = "p", mods = "LEADER", action = act.ActivateCommandPalette },
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "]", mods = "LEADER", action = act({ PasteFrom = "Clipboard" }) },
	{ key = "c", mods = "LEADER", action = act({ CopyTo = "Clipboard" }) },
	{ key = "v", mods = "CMD", action = act({ PasteFrom = "Clipboard" }) },
	{ key = "c", mods = "CMD", action = act({ CopyTo = "Clipboard" }) },

	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
}

-- and finally, return the configuration to wezterm
return config
