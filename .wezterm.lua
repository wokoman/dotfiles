local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- C O N F I G   T I M E (◔◡◔✿) --
config.color_scheme = 'Monokai (base16)'
config.font = wezterm.font('IBM Plex Mono', { weight = 'Medium', italic = false })
config.font_size = 16.0
config.keys = {
    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    { key = 'LeftArrow',  mods = 'OPT', action = act.SendString '\x1bb' },
    -- Make Option-Right equivalent to Alt-f; forward-word
    { key = 'RightArrow', mods = 'OPT', action = act.SendString '\x1bf' },
}
--

return config
