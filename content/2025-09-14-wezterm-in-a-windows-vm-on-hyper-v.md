Title: WezTerm in a Windows VM on Hyper-V
Date: 2025-09-14 14:00
Tags: WezTerm, Bash, Windows
Slug: wezterm-in-a-windows-vm-on-hyper-v

I recently found myself trying to run [WezTerm](https://wezterm.org) in a wimpy Win11 Hyper-V VM that lacked a discrete GPU. On this VM, WezTerm failed to launch with the error:

```
C:\Users\User>wezterm
...snip...
Failed to create window: The OpenGL implementation is too old to work with glium
```

And if you try to launch WezTerm via the GUI or start menu, you simply see nothing; WezTerm silently fails to launch. In that situation you must check logs for the error in the log dir: `C:\Users\<your user>\.local\share\wezterm`

This helpful issue describes using the config option [prefer_egl=true](https://wezterm.org/config/lua/config/prefer_egl.html) when encountering the same issue in a VirtualBox VM:

[https://github.com/wezterm/wezterm/issues/1813#issuecomment-1088749686](https://github.com/wezterm/wezterm/issues/1813#issuecomment-1088749686)

As in that issue, in my Hyper-V Win11 VM `prefer_egl=true` allows WizTerm to launch:

```
wezterm.exe --config prefer_egl=true
```

And permanently setting that value in your `%USERPROFILE%\.wezterm.lua` file looks like:

```lua
local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.prefer_egl = true

config.color_scheme = "Material Darker (base16)"
config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe", "--login", "-i" }
return config
```

This all goes to show that WezTerm is built to take advantage of your system's GPU. For some reason that didn't really hit home for me until trying to run it on an underpowered machine.
