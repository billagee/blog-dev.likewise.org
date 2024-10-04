Title: Selenium 2 .NET test drive
Date: 2011-07-10T22:29:00-07:00
Tags: Selenium, WebDriver, C#
Slug: selenium-2-net-test-drive
Alias: /2011/07/selenium-2-net-test-drive.html

Inaugural post!

Big news - Selenium 2 was released a few days ago:

<a target="_blank" href="http://seleniumhq.wordpress.com/2011/07/08/selenium-2-0/">http://seleniumhq.wordpress.com/2011/07/08/selenium-2-0/</a>

This is a big deal, considering the impressive results Selenium 2 can yield, not to mention the time and effort that went into the project.

So, what better way to launch a blog about testing than with an Se2 trip report?

To take Selenium 2 for a spin, I settled on these requirements for using it with my web app under test:

- Use the C# client (since I already had an existing NUnit project that would be a good place to store Selenium test code)
- Use IE8 on Windows XP (I know, I know...but why not start with a challenge?)

Here are my notes on a few interesting portions of the test drive:

### Installation and first steps

Selenium 2 really shines in this phase. Setup is painless - I just had to:

- Visit <a target="_blank" href="http://seleniumhq.org/download/">http://seleniumhq.org/download/</a>
- Find the C# (Selenium WebDriver) 2.0.0 download link
- Download and unzip selenium-dotnet-2.0.0.zip
- Make a new C# console project (I used Visual Studio 2008)
- In the project, add references to all the .dlls from the zipfile

Here's a simple C# program that launches IE and requests www.google.com:

    :::c#
    using OpenQA.Selenium;
    using OpenQA.Selenium.IE;
    using System;

    namespace SeFoo
    {
        class Program
        {
            static void Main(string[] args)
            {
                IWebDriver driver = new InternetExplorerDriver();
                driver.Navigate().GoToUrl("http://www.google.com");
                driver.Quit();
            }
        }
    }

More info on getting started can be found in the Selenium docs:

<a target="_blank" href="http://seleniumhq.org/docs/03_webdriver.html">http://seleniumhq.org/docs/03_webdriver.html</a>

### Cleanup

Note that when using the .NET bindings, it's important to use:

    :::c#
    driver.Quit();

...when wrapping up your test, because otherwise you can leave a large temp file behind on disk.

For more on that, see this bug report:

<a target="_blank" href="http://code.google.com/p/selenium/issues/detail?id=1140">http://code.google.com/p/selenium/issues/detail?id=1140</a>

### Switching between frames

Right off the bat, I needed to access an element in an iframe, and discovered that frames require special treatment.  Searches for elements in iframes fail unless you explicitly tell Selenium that you need to work within a frame.

I recall frames were always a special case in Watir as well.

This isn't really an issue, though - just use SwitchTo(). This code tells Selenium to target the first iframe in the document, so elements in the iframe will become accessible:

    :::c#
    IWebElement iframe = driver.FindElement(By.TagName("iframe"));
    driver.SwitchTo().Frame(iframe);

### IE8 Click() issue:

Next I hit a roadblock after discovering IE8 appears to ignore Click() calls on form submit buttons, at least on my WinXP machine.

For more info, see this bug report:

<a target="_blank" href="http://code.google.com/p/selenium/issues/detail?id=1415">http://code.google.com/p/selenium/issues/detail?id=1415</a>

A very brief search turned up a few other Selenium bug reports that may or may not be duplicates of that one, too.

Issue 1415 is marked WONTFIX at the moment. Regardless, this simple workaround worked for me:

    :::c#
    submitbutton.SendKeys(Keys.Enter);

### Waiting with WebDriver

After using the ```SendKeys()``` workaround, my program promptly broke down on the next statement, due to searching for an element that hadn't rendered in the browser yet.

Since ```SendKeys()``` doesn't block, you must handle polling for the next element on your own.

Turns out this is pretty easy to do, using the ```WebDriverWait``` support class.

Just add this ```using``` statement:

    :::c#
    using OpenQA.Selenium.Support.UI;

Then add your wait code:

    :::c#
    // Wait 10s for the element to appear
    WebDriverWait tenSecWait = new WebDriverWait(
        driver, new TimeSpan(0, 0, 10));
    // Find element with ID "foo"
    IWebElement theElement = tenSecWait.Until(
        x => x.FindElement(By.Id("foo")));

### Locating elements by text with XPath versus CSS selectors

I needed to locate an h3 element with no attributes at all - just unique inner text. &nbsp;No name or ID, etc.

Unless I missed something, there doesn't seem to be a built-in WebDriver method for this scenario.

So, I used an XPath query:

    :::c#
    IWebElement myElement = driver.FindElement(
        By.XPath("//h3[text() = 'someUniqueText']"));

A little digging revealed that in Selenium 1, an alternate way to do this was apparently this equivalent CSS selector:

    :::bash
    h1:contains("someUniqueText")

But the latter doesn't appear to work in Selenium 2 since ```contains()``` is not actually part of CSS3; it's just sugar available in Selenium 1 (and jQuery), from what I can tell.

More info on that can be found at:

<a target="_blank" href="http://groups.google.com/group/webdriver/browse_thread/thread/a8d4541bdb3ed439">http://groups.google.com/group/webdriver/browse_thread/thread/a8d4541bdb3ed439</a>

<a target="_blank" href="http://stackoverflow.com/questions/4781141/why-h3nth-child1containsa-selector-doesnt-work">http://stackoverflow.com/questions/4781141/why-h3nth-child1containsa-selector-doesnt-work</a>

So, in the end I kept using XPath in this situation.

NOTE: Another useful fix in this situation is to modify the app under test, if possible, so that the element to locate has a unique attribute. Then there's no need to use XPath or CSS selectors at all. :)

### Scrolling elements into view

A hiccup arose when I tried to ```Click()``` an element that was scrolled slightly out of view inside a scrolling div.

For some reason the click didn't bring the element into focus; instead the click went to an element that was immediately "on top", so to speak, of the element I wanted.

I assume this might be because the browser (or WebDriver) thinks the element is displayed even though moving a scrollbar a bit is necessary to see it.

This JS workaround solved the problem (where ```theLink``` was the IWebElement object I wanted to click):

    :::c#
    IJavaScriptExecutor js = driver as IJavaScriptExecutor;
    js.ExecuteScript("arguments[0].scrollIntoView(true);", theLink);

### In Summary

With all the issues above dealt with, I ended up with a fairly robust and useful test program, in a surprisingly short time.  And with more polish things will just get better.

I have to say I'm really impressed with the Selenium 2 .NET bindings. Very very cool stuff!
