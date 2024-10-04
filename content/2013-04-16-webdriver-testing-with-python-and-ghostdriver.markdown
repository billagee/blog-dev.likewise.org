Title: Headless Selenium WebDriver Testing With Python and Ghost Driver
Date: 2013-04-16 23:34
Tags: Selenium, WebDriver, Automation, PhantomJS, GhostDriver, Python, Testing
Slug: webdriver-testing-with-python-and-ghostdriver

<a target="_blank" href="https://github.com/detro/ghostdriver/">GhostDriver</a> is a project that lets you write Selenium WebDriver automation tests that run using the <a target="_blank" href="http://phantomjs.org/">PhantomJS</a> headless WebKit, instead of a traditional web browser.

Put another way, PhantomJS can replace Firefox and friends in your WebDriver scripts - and it doesn't require a display, so testing complex web apps from the command line is just about as easy as using a GUI browser. Very cool!

Getting your system ready to run Python scripts that use GhostDriver can be done in a few brief steps, if you have homebrew on OS X.

First you'll need the Selenium python package:

```
sudo pip install selenium
```

Then, use homebrew to install PhantomJS:

```
brew install phantomjs
```

If you don't want to use homebrew (or you're not on a Mac) you can simply <a target="_blank" href="http://phantomjs.org/download.html">download the latest PhantomJS build manually</a> and install it.

Believe it or not, that is all. GhostDriver is integrated into PhantomJS, so you should now be set up to take a test drive.

A typical Hello World program in the web automation world is one that performs a Google search. So, here's what that looks like in Python and GhostDriver, using Python in interactive mode:

```
$ python

>>> from selenium import webdriver
>>> driver = webdriver.PhantomJS('phantomjs')
>>> driver.get("http://www.google.com")
>>> driver.title
u'Google'
>>> driver.current_url
u'http://www.google.com/'
>>> driver.find_element_by_name("q").is_displayed()
True
>>> driver.find_element_by_name("q").send_keys("selenium")
>>> driver.find_element_by_name("btnG").click()
>>> driver.current_url
u'http://www.google.com/search?hl=en&source=hp&q=selenium&gbv=2&oq=selenium'
```

A natural next step, when developing automated test cases based on experiments like the one above, is to start storing your code into a Python unittest script.

Here's an example of how one might start organizing the code above:

{% gist 5402386 test_google_ghost_driver.py %}

If all is right with the world, running the above script will print output along the lines of the text below.

```
$ ./test_google_ghost_driver.py
current_url is now 'http://www.google.com/search?hl=en&source=hp&q=selenium&gbv=2&oq=selenium'
.
----------------------------------------------------------------------
Ran 1 test in 2.770s

OK
```

That's all for the moment. Now, go forth and Ghost Drive!
