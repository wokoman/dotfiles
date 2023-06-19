local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- C O N F I G   T I M E (◔◡◔✿) --
config.color_scheme = 'Monokai (base16)'
config.font = wezterm.font('IBM Plex Mono', { weight = 'Medium', italic = false })
config.font_size = 16.0
--

return config
