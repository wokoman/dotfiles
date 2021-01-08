import os
import socket
import subprocess

from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "alacritty"

keys = [
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc='rofi dRun Launcher'),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.layout.next(),
        desc="Move window focus to other window"),

    # Move windows
    Key([mod, "control"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "control"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "control"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "control"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows
    Key([mod, "shift"], "h", lazy.layout.grow(), lazy.layout.increase_nmaster(),
        desc="Expand window (MonadTall), increase number in master pane (Tile)"),
    Key([mod, "shift"], "l", lazy.layout.shrink(), lazy.layout.decrease_nmaster(),
        desc="Shrink window (MonadTall), decrease number in master pane (Tile)"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between different layouts
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "m", lazy.layout.maximize(), desc="Maximize window size ratios"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "shift"], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),

    # Volume control
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),

    # Media control
    Key([], "XF86AudioNext",
        lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev",
        lazy.spawn("playerctl previous")),
    Key([], "XF86AudioPlay",
        lazy.spawn("playerctl play-pause")),

    # Brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl set +10%")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl set 10%-")),

    # Screenshots
    Key([mod], "Print", lazy.spawn(["sh", "-c", "maim -u ~/Pictures/screenshot/screen_$(date +%Y-%m-%d-%T).png"])),
    Key([mod, "shift"], "Print", lazy.spawn(["sh", "-c", "maim -s ~/Pictures/screenshot/area_$(date +%Y-%m-%d-%T).png"])),
    Key([mod, "control"], "Print",
        lazy.spawn(["sh", "-c", "maim -u -i $(xdotool getactivewindow) ~/Pictures/screenshot/window_$(date +%Y-%m-%d-%T).png"]))
]

group_names = [("WORK", {'layout': 'monadtall'}),
               ("MINE", {'layout': 'monadtall'}),
               ("CHAT", {'layout': 'monadtall'}),
               ("MUSIC", {'layout': 'monadtall'})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))        # Switch to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group

layout_theme = {"border_width": 2,
                "margin": 6,
                "border_focus": "ead61c",
                "border_normal": "1D2330"
                }


layouts = [
    # layout.Columns(border_focus_stack='#d75f5f'),
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

colors = [["#292d3e", "#292d3e"], # panel background
          ["#434758", "#434758"], # background for current screen tab
          ["#ffffff", "#ffffff"], # font color for group names
          ["#ead61c", "#ead61c"], # border line color for current tab
          ["#594327", "#594327"], # border line color for other tab and odd widgets
          ["#7C5E36", "#7C5E36"], # color for the even widgets
          ["#d7c797", "#d7c797"]] # window name

prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

widget_defaults = dict(
    font='IBM Plex Mono SemiBold',
    fontsize=15,
    padding=3,
    background=colors[2]
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Sep(
                    linewidth = 0,
                    padding = 6,
                    foreground = colors[2],
                    background = colors[0]
                    ),
                widget.GroupBox(
                    fontsize = 12,
                    margin_y = 3,
                    margin_x = 0,
                    padding_y = 5,
                    padding_x = 3,
                    borderwidth = 3,
                    active = colors[2],
                    inactive = colors[2],
                    rounded = False,
                    highlight_color = colors[1],
                    highlight_method = "line",
                    this_current_screen_border = colors[3],
                    this_screen_border = colors [4],
                    other_current_screen_border = colors[0],
                    other_screen_border = colors[0],
                    foreground = colors[2],
                    background = colors[0]
                    ),
                widget.Prompt(
                    prompt = prompt,
                    padding = 10,
                    foreground = colors[3],
                    background = colors[1]
                    ),
                widget.Sep(
                    linewidth = 0,
                    padding = 40,
                    foreground = colors[2],
                    background = colors[0]
                    ),
                widget.WindowName(
                    foreground = colors[6],
                    background = colors[0],
                    padding = 0
                    ),
                widget.TextBox(
                    font = 'MesloLGS NF',
                    text = '',
                    background = colors[0],
                    foreground = colors[5],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.TextBox(
                    font = 'MesloLGS NF',
                    text = " 🖬",
                    foreground = colors[2],
                    background = colors[5],
                    padding = 0,
                    fontsize = 14
                    ),
                widget.Memory(
                    foreground = colors[2],
                    background = colors[5],
                    mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn(terminal + ' -e htop')},
                    padding = 5
                    ),
                widget.TextBox(
                    font = 'MesloLGS NF',
                    text='',
                    background = colors[5],
                    foreground = colors[4],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.Net(
                    interface = "eno2",
                    format = '{down} ↓↑ {up}',
                    foreground = colors[2],
                    background = colors[4],
                    padding = 5
                    ),
                widget.TextBox(
                    font = 'MesloLGS NF',
                    text = '',
                    background = colors[4],
                    foreground = colors[5],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.TextBox(
                    text = "",
                    foreground = colors[2],
                    background = colors[5],
                    padding = 0,
                    fontsize = 22
                    ),
                widget.Volume(
                    foreground = colors[2],
                    background = colors[5],
                    padding = 5
                    ),
                widget.TextBox(
                    font = 'MesloLGS NF',
                    text = '',
                    background = colors[5],
                    foreground = colors[4],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.CurrentLayoutIcon(
                    custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
                    foreground = colors[0],
                    background = colors[4],
                    padding = 0,
                    scale = 0.7
                    ),
                widget.CurrentLayout(
                    foreground = colors[2],
                    background = colors[4],
                    padding = 5
                    ),
                widget.TextBox(
                    font = 'MesloLGS NF',
                    text = '',
                    background = colors[4],
                    foreground = colors[5],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.KeyboardLayout(
                    foreground = colors[2],
                    background = colors[5],
                    configured_keyboards = ['us','cz']
                    ),
                widget.TextBox(
                    text = '',
                    background = colors[5],
                    foreground = colors[4],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.TextBox(
                    text = " ",
                    foreground = colors[2],
                    background = colors[4],
                    padding = 0,
                    fontsize = 11
                    ),
                widget.Battery(
                    foreground = colors[2],
                    background = colors[4],
                    ),
                widget.TextBox(
                    text = '',
                    background = colors[4],
                    foreground = colors[5],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.Clock(
                    format='%d.%m.%Y %a × %H:%M',
                    foreground = colors[2],
                    background = colors[5],
                    ),
                widget.Sep(
                    linewidth = 0,
                    padding = 6,
                    foreground = colors[2],
                    background = colors[5]
                    ),
                widget.TextBox(
                    text = '',
                    background = colors[5],
                    foreground = colors[4],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.Systray(
                    padding = 5,
                    foreground = colors[2],
                    background = colors[4]
                    ),
                widget.Sep(
                    linewidth = 0,
                    padding = 6,
                    foreground = colors[2],
                    background = colors[4]
                    ),
            ],
            24,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    Match(wm_type='utility'),
    Match(wm_type='notification'),
    Match(wm_type='toolbar'),
    Match(wm_type='splash'),
    Match(wm_type='dialog'),
    Match(wm_class='file_progress'),
    Match(wm_class='confirm'),
    Match(wm_class='dialog'),
    Match(wm_class='download'),
    Match(wm_class='error'),
    Match(wm_class='notification'),
    Match(wm_class='splash'),
    Match(wm_class='toolbar'),
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
