import os

from libqtile import bar, widget
from libqtile.config import Screen
import libqtile.resources
from libqtile.lazy import lazy

logo = os.path.join(os.path.dirname(libqtile.resources.__file__), "logo.png")

widget_defaults = dict(
    font="Terminess Nerd Font Mono",
    # font="3270 Nerd Font SemCond",
    fontsize=15,
    padding=5,
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
        # -
        widget.Spacer(),
        # -
        widget.Chord(),
        widget.CPU(format="CPU {freq_current}GHz {load_percent}%"),
        widget.Memory(format="| {MemUsed: .0f}{mm}"),
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
            mouse_callbacks={
                "Button1": lazy.spawn("cinnamon-settings network"),
            },
        ),
        widget.Clock(format="| %d-%m %a | %I:%M %p"),
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
                size=24,
                opacity=0.9,
                background="#282A2E",
                # background="#393939",
                margin=[3, 3, 0, 3],
            ),
            background="#000000",
            wallpaper="~/Pictures/Wallpapers/tree.png",
            wallpaper_mode="stretch",
            x11_drag_polling_rate=60,
        ),
    ]


screens = init_screens()
