Title: Setting up XScreenSaver on Ubuntu 16.04
Date: 2017-01-22 19:00
Tags: Ubuntu, XScreenSaver
Slug: setting-up-xscreensaver-on-ubuntu-1604

[comment]: <>  ( ![xscreensaver-config screenshot]({attach}images/xscreensaver-config.png){:height="36px" width="36px"} )

![xscreensaver-config screenshot]({attach}images/xscreensaver-config.png){:height="60%" width="60%"}

Do you have a burning desire (or a mandatory policy) to make your Ubuntu machine lock its display when you step away?

Or do you have a fondness (maybe a _burn-in_ desire?) for a time when screensavers had other uses?

If so, this post describes how I installed XScreenSaver (and optional-but-essential add-ons like the <a target="_blank" href="https://www.youtube.com/watch?v=Q54NVuxhGso">CompanionCube screensaver</a>) on Ubuntu 16.04.

This script takes care of everything you need - just paste this into a shell script and run it, or paste each command one at a time.

These steps are based on the Unity setup notes in <a target="_blank" href="https://www.jwz.org/xscreensaver/man1.html">the xscreensaver man page</a>:

```
# Install xscreensaver and addons:

sudo apt-get install \
    xscreensaver xscreensaver-data-extra \
    xscreensaver-gl xscreensaver-gl-extra

# Uninstall the gnome-screensaver package:

sudo apt-get remove gnome-screensaver

# Make GNOME's "Lock Screen" use xscreensaver:

sudo ln -sf /usr/bin/xscreensaver-command \
            /usr/bin/gnome-screensaver-command

# Turn off Unity's built-in blanking.
# NOTE: For more options see 'gsettings list-keys org.gnome.desktop.screensaver'

# These two are equivalent to going to "System Settings / Brightness & Lock" and:
# * Setting "Turn screen off when inactive for" to "Never"
# * Switching the "Lock" toggle button to OFF
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.screensaver lock-enabled false

# Configure xscreensaver as a startup application:

mkdir -p ~/.config/autostart

echo "[Desktop Entry]
Type=Application
Exec=xscreensaver -nosplash
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=xscreensaver
Name=xscreensaver
Comment[en_US]=
Comment=
" > ~/.config/autostart/xscreensaver.desktop
```

Once the install is complete, launch the `xscreensaver-demo` config util to pick the list of screensavers to run (among other settings).

Useful settings here are the "Blank After" and "Lock Screen After" values. You can change those if you need to lock your screen after a shorter idle time than the default values:

```
xscreensaver-demo
```

Mostly for my own reference, these are the screensavers I currently have enabled in my config file (```/home/bill/.xscreensaver```):

```
bill@foo:~$ cat /home/bill/.xscreensaver | grep "^  GL"
  GL: 				lament -root -fps			   \n\
  GL: 				sonar -root				   \n\
  GL: 				stairs -root				   \n\
  GL: 				sierpinski3d -root			   \n\
  GL: 				molecule -root				   \n\
  GL: 				glmatrix -root				   \n\
  GL: 				polyhedra -root				   \n\
  GL: 				glhanoi -root				   \n\
  GL: 				tangram -root				   \n\
  GL: 				topblock -root				   \n\
  GL: 				companioncube -root -count 9		   \n\
  GL: 				kaleidocycle -root			   \n\
  GL: 				unknownpleasures -root			   \n\
  GL: 				splitflap -root				   \n\
```
