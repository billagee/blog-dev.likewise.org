Title: SHDocVw.ShellWindows and IWebBrowser2 in C#, the easy way
Date: 2012-03-31T10:54:00-07:00
Tags: IWebBrowser2, Internet Explorer, SHDocVw, C#
Slug: shdocvwshellwindows-and-iwebbrowser2-in
Alias: /2012/03/shdocvwshellwindows-and-iwebbrowser2-in.html

Not too long ago I needed to write some test setup code in C# to check for open IE windows.

The idea was to kill any running IE instances before entering the main portion of the test case - and just for reference, I wanted to record the URL that each closed IE window had been viewing.

My first thought was to use this common technique:

- Enumerate the SHDocVw.ShellWindows collection, looking for IE processes
- Use IE's IWebBrowser2 COM interface to interact with any IE instances found

Turns out this is a common question for C# projects - and there seem to be some overly convoluted solutions floating around.

However, one solution is quite easy - the key point is that the friendly name of the SHDocVw type library is "Microsoft Internet Controls".

So, if you add a reference to the "Microsoft Internet Controls" COM component in your C# project, you'll be able to use SHDocVw.ShellWindows and SHDocVw.IWebBrowser2.

![Visual Studio screenshot]({attach}images/ms_int_controls-big.png)

This example code (for VS 2012) shows how to access the IWebBrowser2 interface of each running IE:

<script src="https://gist.github.com/billagee/46a1ea83b59f13146567cb779dd003b0.js"></script>

Back in the VS 2008 days, different code was used to accomplish the same thing:

<script src="https://gist.github.com/2267093.js?file=gistfile1.cs"></script>

Full disclosure - I also wrote a <a target="_blank" href="http://stackoverflow.com/questions/6530083/cannot-add-c-windows-system32-shdocvw-dll-to-my-project/8541532#8541532">stackoverflow answer about this topic</a>.
