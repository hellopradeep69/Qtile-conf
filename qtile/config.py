import os


import libqtile.resources
import subprocess

from libqtile import hook
from libqtile import bar, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"
alt = "mod1"  # Alt
terminal = guess_terminal()

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.group.prev_window(), desc="Toggle btw last two windows"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key(
        [mod],
        "t",
        lazy.window.toggle_floating(),
        desc="Toggle floating on the focused window",
    ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # My Keybinds | hello pradeep
    Key(
        [alt],
        "space",
        lazy.spawn("/home/hellopradeep/.local/bin/internetq.sh"),
        desc="Internet qtile",
    ),
    Key([mod], "p", lazy.hide_show_bar("top"), desc="Toggle top bar"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "Return", lazy.spawn("wezterm"), desc="Launch terminal"),
    Key([mod], "b", lazy.spawn("zen"), desc="Launch browser"),
    Key([alt], "h", lazy.screen.prev_group(), desc="Switch to previous workspace"),
    Key([alt], "l", lazy.screen.next_group(), desc="Switch to next workspace"),
    Key(
        ["control"],
        "space",
        lazy.spawn("rofi -show drun"),
        desc="Switch to next workspace",
    ),
    Key(
        [mod, "shift"],
        "space",
        lazy.window.toggle_floating(),
        desc="Toggle floating",
    ),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key(
        [],
        "XF86MonBrightnessUp",
        lazy.spawn("brightnessctl set +5%"),
        desc="Increase brightness",
    ),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn("brightnessctl set 5%-"),
        desc="Decrease brightness",
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +10%"),
        desc="Volume up",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%"),
        desc="Volume down",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="Mute/unmute",
    ),
    Key(
        [alt],
        "Return",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen",
    ),
    Key(
        [],
        "Menu",
        lazy.spawn("/home/hellopradeep/.local/bin/rofi-clipboard"),
        desc="Rofi clipboard menu",
    ),
    Key([], "Print", lazy.spawn("gnome-screenshot"), desc="Full screenshot"),
    Key(
        ["shift"],
        "Print",
        lazy.spawn("gnome-screenshot -a"),
        desc="Screenshot selected area",
    ),
]

# Add key bindings to switch VTs in Wayland.
# We can't check qtile.core.name in default config as it is loaded before qtile is started
# We therefore defer the check until the key binding is run by using .when(func=...)
for vt in range(1, 8):
    keys.append(
        Key(
            ["control", "mod1"],
            f"f{vt}",
            lazy.core.change_vt(vt).when(func=lambda: qtile.core.name == "wayland"),
            desc=f"Switch to VT{vt}",
        )
    )

# groups = [Group(i) for i in "1234567890"]

# My Groups
groups = [
    Group("1"),
    Group("2", matches=[Match(wm_class="zen")]),
    Group("3", matches=[Match(wm_class="nemo")]),
    Group("4"),
    Group("5"),
    Group("6"),
    Group("7"),
    Group("8"),
    Group("9"),
    Group(
        "0",
        layout="treetab",
        matches=[
            Match(wm_class="Telegram"),
            Match(wm_class="cinnamon-settings network"),
        ],
    ),
]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc=f"Switch to & move focused window to group {i.name}",
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layout_value = {
    "border_focus": "#d9d0c0",  # Focused window border color
    "border_normal": "#010000",  # Unfocused window border color
    "border_on_single": True,  # Show border even for single window
    "border_width": 1,  # Border thickness
    "margin": 6,  # Gap around windows
}

layout_value1 = {
    "border_focus": "#d9d0c0",  # Focused window border color
    "border_normal": "#010000",  # Unfocused window border color
    "border_on_single": False,  # Show border even for single window
    "border_width": 1,  # Border thickness
}

tree_value = {
    "active_bg": "#2B2826",
    "inactive_bg": "#000000",
    "active_fg": "#ffffff",
    "font": "Terminess Nerd Font Mono",
    "panel_width": 150,
}

layouts = [
    layout.Bsp(**layout_value1),  # bspwm alike
    layout.Plasma(**layout_value1),
    layout.RatioTile(**layout_value1),  # mmm i kinda like it
    layout.TreeTab(**tree_value),
    # Try more layouts by unleashing below layouts.
    # layout.Columns(**layout_value),
    # layout.Zoomy(**layout_value1), # tree but with lil preview
    # layout.Tile(**layout_value1),  # it push focus to side
    # layout.MonadTall(**layout_value1),  # arrange in same format even tho focus on win
    # layout.MonadWide(**layout_value1),  # same as tall but wide
    # layout.Matrix(**layout_value1),  # good for show off
    # layout.VerticalTile(**layout_value1), # absolute stupid
    # layout.Max(),  # no
    # layout.Stack(num_stacks=2, **layout_value1),  # not best
]

widget_defaults = dict(
    # font="Iosevka Nerd Font",
    font="Terminess Nerd Font Mono",
    # font="JetBrainsMono Nerd Font",
    fontsize=15,
    padding=7,
)
extension_defaults = widget_defaults.copy()

logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(
                    highlight_method="line",
                    highlight_color=["#373B41", "#282828"],
                    this_current_screen_border="#d9d0c0",
                ),
                widget.Prompt(),
                widget.WindowName(
                    format="{name}",
                    max_chars=40,
                    empty_group_string=" hellopradeep",
                ),
                widget.Memory(format="{MemUsed: .0f}{mm}"),
                widget.PulseVolume(
                    fmt="| Vol: {}",
                ),
                widget.Battery(
                    charge_char="CHA",
                    discharge_char="BAT",
                    format="| {char} {percent:2.0%}",
                    charge_controller=lambda: (0, 80),
                    update_interval=15,
                ),
                widget.Wlan(
                    format="| {essid}",
                    interface="wlp2s0",
                    disconnected_message="| Disconnected",
                ),
                widget.Clock(format="| %m-%d %a | %I:%M %p"),
                widget.Backlight(
                    backlight_name="amdgpu_bl1",
                    step=5,
                    format="| {percent:2.0%}   ",
                ),
            ],
            30,
            opacity=0.9,
            background="#282A2E",
            # background="#393939",
            # margin=[5, 5, 0, 5],
            margin=[3, 3, 0, 3],
            name="hello_bar",
        ),
        # left=bar.Bar(
        #     [
        #         widget.Spacer(background="#393939"),
        #         widget.VerticalClock(fontsize=20),
        #         widget.Spacer(background="#393939"),
        #     ],
        #     30,  # width
        #     opacity=0.5,
        #     background="#393939",
        #     margin=[3, 3, 3, 3],
        # ),
        background="#000000",
        wallpaper="~/Pictures/Wallpapers/tree.png",
        wallpaper_mode="stretch",
        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        x11_drag_polling_rate=60,
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
floating_layout = layout.Floating(
    border_focus="#979186",
    border_normal="#000000",
    border_width=1,
    # Rules
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="Gnome-screenshot"),
        Match(title="Select Area"),
    ],
)
auto_fullscreen = True
focus_on_window_activation = "focus"
focus_previous_on_window_remove = False
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


# Hook | Autostart
@hook.subscribe.startup_once
def autostart():
    script = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.run([script])


# Rule opener for app
@hook.subscribe.client_new
def move_to_group(window):
    wm_class = window.window.get_wm_class()
    if wm_class and "Telegram" in wm_class:
        window.togroup("0")
    elif wm_class and "vlc" in wm_class:
        window.togroup("3")
        window.qtile.groups_map["3"].cmd_toscreen()
    elif wm_class and "nemo" in wm_class:
        window.togroup("3")
        window.qtile.groups_map["3"].cmd_toscreen()
