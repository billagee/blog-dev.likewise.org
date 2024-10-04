Title: Raspberry Pi terminal screenshots with fbgrab
Date: 2013-01-13 11:26
Tags: Raspberry Pi
Slug: raspberry-pi-terminal-screenshots-with-fbgrab

Say you're on the console on your Raspberry Pi, and you want to take a screenshot. But without X running, what does one do?

Simple: Use fbgrab. To install it, just:

```
sudo apt-get install fbgrab
```

Pass fbgrab the name of the virtual terminal/tty you want to snapshot, and it'll spit out a PNG file.

For example, say you have an awesome console program running on /dev/tty1, and want to screenshot it - just run:

```
sudo fbgrab -c 1 screenshot.png
```

And that's it! Here's an example of the output:

![cmus screenshot]({attach}images/screenshot.png)
