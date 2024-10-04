Title: Pure Ruby example of calling functions from the MS IUIAutomation COM interface
Date: 2012-04-14T04:35:00-07:00
Tags: Ruby, windows-pr, IUIautomation, Windows, COM
Slug: pure-ruby-example-of-calling-functions
Alias: /2012/04/pure-ruby-example-of-calling-functions.html

![Placeholder screenshot]({attach}images/print_root_element_name_cmd.png)

A while back I was interested in writing some Ruby code that used functions from the Windows <a target="_blank" href="http://msdn.microsoft.com/en-us/library/windows/desktop/ee671406(v=vs.85).aspx">IUIAutomation COM interface</a>.

But since IUIAutomation is a custom COM interface that doesn't implement <a target="_blank" href="http://en.wikipedia.org/wiki/IDispatch">IDispatch</a>, Ruby's Win32OLE module won't work with it.

And I wanted to avoid using a C extension that wraps UI Automation - see <a target="_blank" href="https://github.com/jarmo/RAutomation">RAutomation</a> for an example of a nice library that takes the C extension approach.

Without using a C extension, the only way I've found to use IUIAutomation in Ruby is to use Windows::COM - which is included in the awesome <a target="_blank" href="https://github.com/djberg96/windows-pr">windows-pr</a> project.

Then, one must pore over the C header file containing the function prototypes you want to use (UIAutomationClient.h in this case) and port each prototype to Ruby one at a time (!).

Note you have to install the <a target="_blank" href="http://www.microsoft.com/download/en/details.aspx?id=3138">the Windows 7 SDK</a> to get a copy of that header file, but you don't need the SDK or .h to simply run the Ruby script shown below.

(For what it's worth, my copy of the header file is at \Program Files\Microsoft SDKs\Windows\v7.1\Include\UIAutomationClient.h)

This is all quite a far cry from how easy the same task is in the CPython world thanks to <a target="_blank" href="http://starship.python.net/crew/theller/comtypes/">comtypes</a>.  But I digress - doing the same thing in Python deserves its own post.

Below is a Ruby script that obtains and prints the name of the root (Desktop) UI automation element on a Windows box - the string should always be "Desktop".

Doing so shows how to use IUIAutomation::GetRootElement() and IUIAutomationElement::get_CurrentName().

Apologies for the convoluted hacks on display - stuff like having to hardcode the number of each function in the IUIAutomationVtbl struct will hopefully have a better solution someday!

NOTE: Before running this you must:

- ```gem install windows-pr```
- If you're using XP or Vista, install the <a target="_blank" href="http://support.microsoft.com/kb/971513">Windows Automation API</a> update from MSFT

<script src="https://gist.github.com/billagee/2383726.js"></script>
