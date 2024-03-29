import base64
import os
import socket
import subprocess

from typing import List  # noqa: F401

from libqtile import qtile, extension
from libqtile.config import Click, Drag, Group, KeyChord, Key, Match, Screen
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from libqtile.lazy import lazy
from typing import List  # noqa: F401

mod = "mod4"
terminal = "alacritty"
owm_api_key = "MDk1MzVmOTk5ZTkwMzU4Njc0ZTc4MmRmMmNlYjc2YzA="

keys = [
    Key([mod], "r", lazy.spawn("rofi -show drun"), desc='rofi dRun Launcher'),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "period", lazy.spawn("splatmoji copypaste"), desc="Emoji menu"),
    Key([mod], "End", lazy.widget["keyboardlayout"].next_keyboard(), desc="Next keyboard layout"),

    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.layout.next(),
        desc="Move window focus to other window"),

    # Move windows
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Switch focus to specific monitor
    Key([mod], "e",
        lazy.to_screen(0),
        desc='Keyboard focus to monitor 1'
        ),
    Key([mod], "q",
        lazy.to_screen(1),
        desc='Keyboard focus to monitor 2'
        ),

    # Switch focus of monitors
    Key([mod], "a",
        lazy.next_screen(),
        desc='Move focus to next monitor'
        ),
    Key([mod], "s",
        lazy.prev_screen(),
        desc='Move focus to prev monitor'
        ),

    # Grow windows
    Key([mod, "control"], "h", lazy.layout.grow(), lazy.layout.increase_nmaster(),
        desc="Expand window (MonadTall), increase number in master pane (Tile)"),
    Key([mod, "control"], "l", lazy.layout.shrink(), lazy.layout.decrease_nmaster(),
        desc="Shrink window (MonadTall), decrease number in master pane (Tile)"),

    # Toggle between different layouts
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "m", lazy.layout.maximize(), desc="Maximize window size ratios"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Quit Qtile"),
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
        lazy.spawn(["sh", "-c", "maim -u -i $(xdotool getactivewindow) ~/Pictures/screenshot/window_$(date +%Y-%m-%d-%T).png"])),

    # Power menu
    Key([mod, "control"], "x", lazy.run_extension(extension.CommandSet(
        commands={
            "shutdown": "systemctl poweroff",
            "reboot": "systemctl reboot",
            "suspend": "systemctl suspend",
            "hibernate": "systemctl hibernate",  # NOTE: A few things need to be set up in advance for this to work.
            "logout": "loginctl terminate-session $XDG_SESSION_ID",
            "switch user": "dm-tool switch-to-greeter",  # "dm-tool" is probably part of something other than systemd
            "lock": "loginctl lock-session",
            },
            # dmenu_prompt="session>",
            )), desc="List options to quit the session.")
]

group_names = [("WORK", {'layout': 'monadtall'}),
               ("DEV", {'layout': 'monadtall'}),
               ("WEB", {'layout': 'monadtall'}),
               ("CHAT", {'layout': 'monadtall'}),
               ("MINE", {'layout': 'monadtall'})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))        # Switch to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name))) # Send current window to another group

layout_theme = {"border_width": 7,
                "margin": 7,
                "border_focus": "7C5E36",
                "border_normal": "292d3e"
                }


layouts = [
    # layout.Columns(border_focus_stack='#d75f5f'),
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme)
]

colors = [["#292d3e", "#292d3e"], # panel background
          ["#434758", "#434758"], # background for current screen tab
          ["#ffffff", "#ffffff"], # font color for group names
          ["#ead61c", "#ead61c"], # border line color for current tab
          ["#594327", "#594327"], # border line color for other tab
          ["#393e56", "#393e56"], # color for the even widgets
          ["#d7c797", "#d7c797"], # window name
          ["#292d3e", "#292d3e"]] # color for the odd widgets

prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

widget_defaults = dict(
    font='IBM Plex Mono SemiBold',
    fontsize=15,
    padding=3,
    background=colors[2]
)
extension_defaults = widget_defaults.copy()

def init_widgets_list():
    widgets_list = [
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
                    padding = 0,
                    ),
                widget.TextBox(
                    font = 'MesloLGS NF',
                    text = '',
                    background = colors[0],
                    foreground = colors[5],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.CPU(
                    format = 'CPU: {load_percent}%',
                    foreground = colors[6],
                    background = colors[5],
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' -e htop')},
                    padding = 5
                    ),
                widget.TextBox(
                    text = " RAM:",
                    foreground = colors[6],
                    background = colors[5],
                    padding = 0,
                    fontsize = 14
                    ),
                widget.Memory(
                    foreground = colors[6],
                    background = colors[5],
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' -e htop')},
                    padding = 5
                    ),
                widget.TextBox(
                    font = 'MesloLGS NF',
                    text='',
                    foreground = colors[7],
                    background = colors[5],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.Net(
                    interface = "eno2",
                    format = '{down} ↓↑ {up}',
                    foreground = colors[6],
                    background = colors[7],
                    padding = 5
                    ),
                widget.TextBox(
                    font = 'MesloLGS NF',
                    text = '',
                    foreground = colors[5],
                    background = colors[7],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.TextBox(
                    text = "",
                    foreground = colors[6],
                    background = colors[5],
                    padding = 0,
                    fontsize = 22
                    ),
                widget.Volume(
                    foreground = colors[6],
                    background = colors[5],
                    padding = 5
                    ),
                widget.TextBox(
                    font = 'MesloLGS NF',
                    text = '',
                    foreground = colors[7],
                    background = colors[5],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.KeyboardLayout(
                    foreground = colors[6],
                    background = colors[7],
                    configured_keyboards = ['us','cz']
                    ),
                widget.Sep(
                    linewidth = 0,
                    padding = 6,
                    foreground = colors[7],
                    background = colors[7]
                    ),
                widget.TextBox(
                    text = '',
                    foreground = colors[5],
                    background = colors[7],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.TextBox(
                    text = " ",
                    foreground = colors[6],
                    background = colors[5],
                    padding = 0,
                    fontsize = 11
                    ),
                widget.Battery(
                    foreground = colors[6],
                    background = colors[5],
                    ),
                widget.TextBox(
                    font = 'MesloLGS NF',
                    text = '',
                    background = colors[5],
                    foreground = colors[7],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.OpenWeather(
                    app_key = base64.b64decode(owm_api_key).decode('ascii'),
                    location = 'Slaný, CZ',
                    format = '{main_temp} °{units_temperature} {weather_details}',
                    padding = 5,
                    foreground = colors[6],
                    background = colors[7]
                    ),
                widget.TextBox(
                    text = '',
                    background = colors[7],
                    foreground = colors[5],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.Clock(
                    format='%d.%m.%Y %a × %H:%M',
                    foreground = colors[6],
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
                    foreground = colors[7],
                    background = colors[5],
                    padding = 0,
                    fontsize = 37
                    ),
                widget.Systray(
                    padding = 5,
                    foreground = colors[2],
                    background = colors[7]
                    ),
                widget.Sep(
                    linewidth = 0,
                    padding = 6,
                    foreground = colors[2],
                    background = colors[7]
                    ),
              ]
    return widgets_list

def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    del widgets_screen2[5:]
    return widgets_screen2

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=1.0, size=30)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=1.0, size=30))]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()

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
    # default_float_rules include: utility, notification, toolbar, splash, dialog,
    # file_progress, confirm, download and error.
    *layout.Floating.default_float_rules
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
