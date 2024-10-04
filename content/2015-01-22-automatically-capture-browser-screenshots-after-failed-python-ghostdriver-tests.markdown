Title: Automatically capture browser screenshots after failed Python GhostDriver tests
Date: 2015-01-22 01:37
Tags: Selenium, WebDriver, Automation, PhantomJS, GhostDriver, Python, Testing
Slug: automatically-capture-browser-screenshots-after-failed-python-ghostdriver-tests

<a href="https://github.com/detro/ghostdriver/">GhostDriver</a> is a fantastic tool, one which I've been happily using for a while now (and have <a href="http://blog.likewise.org/2013/04/webdriver-testing-with-python-and-ghostdriver/">briefly written about</a> before).

I feel it's worth mentioning that troubleshooting GhostDriver tests can seem like a challenge in and of itself if you're used to having a browser GUI to help you visually pinpoint problems in your tests.

This post describes a technique intended to make GhostDriver troubleshooting easier: How to capture a screenshot automatically if your test raises an exception.

Just as in <a href="http://darrellgrainger.blogspot.ca/2011/02/generating-screen-capture-on-exception.html">this blog post by Darrell Grainger</a>, we'll be using the <a href="http://selenium.googlecode.com/svn/branches/safari/docs/api/java/org/openqa/selenium/support/events/EventFiringWebDriver.html">EventFiringWebDriver</a> wrapper to take screenshots after test failures; but here we'll be using the Python WebDriver bindings rather than Java.

On that note, it's worth linking to the <a href="https://code.google.com/p/selenium/source/browse/py/test/selenium/webdriver/support/event_firing_webdriver_tests.py">unit test script for EventFiringWebDriver</a> found in the WebDriver Python bindings repo.

Here's the GhostDriver screenshot demo code - after running it, you should have a screenshot of the google.com homepage left behind in <tt>exception.png</tt>:

    :::python
    #!/usr/bin/env python
    
    # * Note: phantomjs must be in your PATH
    #
    # This script:
    # - Navigates to www.google.com
    # - Intentionally raises an exception by searching for a nonexistent element
    # - Leaves behind a screenshot in exception.png
    
    import unittest
    from selenium import webdriver
    from selenium.webdriver.support.events import EventFiringWebDriver
    from selenium.webdriver.support.events import AbstractEventListener
    
    class ScreenshotListener(AbstractEventListener):
        def on_exception(self, exception, driver):
            screenshot_name = "exception.png"
            driver.get_screenshot_as_file(screenshot_name)
            print("Screenshot saved as '%s'" % screenshot_name)
    
    class TestDemo(unittest.TestCase):
        def test_demo(self):

            pjsdriver = webdriver.PhantomJS("phantomjs")
            d = EventFiringWebDriver(pjsdriver, ScreenshotListener())

            d.get("http://www.google.com")
            d.find_element_by_css_selector("div.that-does-not-exist")
    
    if __name__ == '__main__':
            unittest.main()
