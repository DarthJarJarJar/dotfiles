-- Pull in the wezterm API
local wezterm = require 'wezterm'
local a = wezterm.action
-- This will hold the configuration.

local config = wezterm.config_builder()

-- For example, changing the color scheme:
config.font = wezterm.font 'JetBrains Mono'
config.color_scheme = 'Catppuccin Mocha'
config.font_size = 16.0
config.use_fancy_tab_bar = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_frame = {
  inactive_titlebar_bg = '#1e1e2f',
  active_titlebar_bg = '#1e1e2f',
  inactive_titlebar_fg = '#cccccc',
  active_titlebar_fg = '#ffffff',
  inactive_titlebar_border_bottom = '#1e1e2f',
  active_titlebar_border_bottom = '#1e1e2f',
  button_fg = '#1e1e2f',
  button_bg = '#1e1e2f',
  button_hover_fg = '#ffffff',
  button_hover_bg = '#3b3052',
}

local function is_inside_vim(pane)
  local tty = pane:get_tty_name()
  if tty == nil then return false end

  local success, stdout, stderr = wezterm.run_child_process
    { 'sh', '-c',
      'ps -o state= -o comm= -t' .. wezterm.shell_quote_arg(tty) .. ' | ' ..
      'grep -iqE \'^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$\'' }

  return success
end

local function is_outside_vim(pane) return not is_inside_vim(pane) end

local function bind_if(cond, key, mods, action)
  local function callback (win, pane)
    if cond(pane) then
      win:perform_action(action, pane)
    else
      win:perform_action(a.SendKey({key=key, mods=mods}), pane)
    end
  end

  return {key=key, mods=mods, action=wezterm.action_callback(callback)}
end

config.keys = {
    bind_if(is_outside_vim, 'h', 'CTRL', a.ActivatePaneDirection('Left')),
    bind_if(is_outside_vim, 'l', 'CTRL', a.ActivatePaneDirection('Right')),
    {
    key = ';',
    mods = 'CTRL',
    action = wezterm.action.SplitPane {
      direction = 'Right',
      size = { Percent = 30 },
    },
  },
  {
    key = ';',
    mods = 'CTRL|ALT',
    action = a.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = '\'',
    mods = 'CTRL|ALT',
    action = a.AdjustPaneSize { 'Right', 5 },
  },


}

-- and finally, return the configuration to wezterm
return config
