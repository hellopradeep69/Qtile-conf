import os

from libqtile import bar, widget
from libqtile.config import Screen
import libqtile.resources

logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")

widget_defaults = dict(
    font="Terminess Nerd Font Mono",
    fontsize=15,
    padding=7,
)
extension_defaults = widget_defaults.copy()


def init_widgets_list():
    return [
        widget.CurrentLayout(),
        widget.GroupBox(
            disable_drag=True,
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
        widget.Chord(),
        widget.Memory(format="{MemUsed: .0f}{mm}"),
        widget.PulseVolume(fmt="| Vol: {}"),
        widget.Battery(
            charging_foreground="#B2B2B2",
            low_foreground="#E50000",
            low_percentage=0.35,
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
    ]


def init_screens():
    return [
        Screen(
            top=bar.Bar(
                widgets=init_widgets_list(),
                size=30,
                opacity=0.9,
                background="#282A2E",
                margin=[3, 3, 0, 3],
            ),
            background="#000000",
            wallpaper="~/Pictures/Wallpapers/tree.png",
            wallpaper_mode="stretch",
            x11_drag_polling_rate=60,
        ),
    ]


screens = init_screens()

