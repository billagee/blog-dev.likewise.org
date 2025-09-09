Title: WezTerm and Git Bash on Windows
Date: 2025-09-07 14:00
Tags: WezTerm, Bash, Windows
Slug: wezterm-and-git-bash-on-windows

![wezterm-screenshot]({attach}images/wezterm.png)

If you need to run Bash on Windows, you may have enjoyed using Git Bash, which comes with Git for Windows.

But if you're ready to use Bash with a more full-featured terminal for Windows (especially if you're looking for tab support), WezTerm works very nicely.

Note that I find Windows Terminal a good way to run Git Bash as well, but I enjoy WezTerm a bit more.

The instructions below should help you set up a minimal Git Bash configuration with WezTerm.

## Install Git Bash (by installing Git for Windows)

If you've gotten this far you probably already have Git for Windows installed, but if not, [go install it](https://gitforwindows.org/).

## Install WezTerm

You can download a binary release or the Windows installer from the website - or, use a package manager. I used winget.

Get the latest releases and other details at: [https://wezterm.org/install/windows.html](https://wezterm.org/install/windows.html#installing-on-windows)

## Create the .wezterm.lua config file

WezTerm is configured via a config script placed in your home dir: `.wezterm.lua`

Use your favorite editor to create and populate the file. The location where I place my config file is: `%USERPROFILE%\.wezterm.lua`

See below for a complete example script that will run Git Bash as the default shell. Note there's also a minimal example (which defaults to cmd.exe) in the docs at [https://wezterm.org/config/files.html](https://wezterm.org/config/files.html)

## Customize your config script

You'll notice if you launch WezTerm before creating your config file, it'll run cmd.exe.

To make the default shell Git Bash, here's a `.wezterm.lua` that sets the default shell command line to `C:\Program Files\Git\bin\bash.exe --login -i`:

```lua
-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.initial_cols = 128
config.initial_rows = 28
config.font_size = 11
config.color_scheme = 'BatMan'

-- bash configuration
config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe", "--login", "-i" }

-- and finally, return the configuration to wezterm
return config
```

Save your changes and launch WizTerm. Note that if you already have WezTerm open, it hot-reloads the file, so you can see your tweak results without closing it!

## Customize

See details on other features and customizing the appearance of WezTerm over at [https://wezterm.org/config/appearance.html](https://wezterm.org/config/appearance.html).

I particularly love that WizTerm ships with every color scheme I've used in the past with iTerm2, Windows Terminal, and other terminal apps. There's no need to locate and set up the themes separately. Amazing.

See the full list of themes at: [https://wezterm.org/colorschemes/index.html](https://wezterm.org/colorschemes/index.html)

Have fun!
