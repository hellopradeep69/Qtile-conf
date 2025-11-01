import os
import subprocess
from libqtile import hook


# --- Autostart Script ---
@hook.subscribe.startup_once
def autostart():
    script = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.run([script])


# --- Auto move apps to workspaces ---
@hook.subscribe.client_new
def move_to_group(window):
    wm_class = window.window.get_wm_class()
    if wm_class and "Telegram" in wm_class:
        window.togroup("0")
    elif wm_class and "vlc" in wm_class:
        window.togroup("4")
    elif wm_class and "nemo" in wm_class:
        window.togroup("4")
