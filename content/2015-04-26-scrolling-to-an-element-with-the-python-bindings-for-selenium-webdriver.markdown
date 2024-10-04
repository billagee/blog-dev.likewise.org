Title: Scrolling to an Element with the Python Bindings for Selenium WebDriver
Date: 2015-04-26 23:43
Tags: Selenium, WebDriver, Automation, Chrome, Python, Testing
Slug: scrolling-to-an-element-with-the-python-bindings-for-selenium-webdriver

When using <a href="http://docs.seleniumhq.org/docs/03_webdriver.jsp">Selenium WebDriver</a>, you might encounter a situation where you need to scroll an element into view.

By running the commands in the following steps, you can interactively try out a solution using Google Chrome.

### 1. Set up a scratch environment and install the selenium package

My usual habit when starting a scratch project like this one is to set up a clean Python environment with virtualenv:

```bash
# In your shell:
mkdir scrolling
cd scrolling/
virtualenv env
. env/bin/activate
pip install selenium
```

### 2. Launch the Python interpreter, open a Chrome session with the selenium package, and navigate to Google News

```python
$ python
...
>>> from selenium import webdriver
>>> d = webdriver.Chrome()
>>> d.get("http://news.google.com/")
```

### 3. Identify the element that serves as the heading for the "Most popular" section of the page, then scroll to it by executing the JavaScript scrollIntoView() function

``` python
>>> element = d.find_element_by_xpath("//span[.='Most popular']")
>>> element.text
u'Most popular'
>>> d.execute_script("return arguments[0].scrollIntoView();", element)
```

Note that the Python WebDriver bindings also offer the <a href="https://selenium-python.readthedocs.org/api.html#selenium.webdriver.remote.webelement.WebElement.location_once_scrolled_into_view">location_once_scrolled_into_view</a> property, which currently scrolls the element into view when retrieved.

However, that property is noted in the selenium module docs as subject to change without warning - and it also places the element at the bottom of the viewport (rather than the top), so I prefer using scrollIntoView().

### 4. Scroll the element a few px down toward the center of the viewport, if necessary

After the code above scrolls the element to the top of the window, you may find you need to scroll the document backwards to scoot the element slightly towards the center of the window - this can be necessary if the element is hidden under another element (for example, a toolbar that blocks clicks to the element you're interested in).

Such scrolling is easy to do - this JS scrolls the document backwards by 150px, placing your element closer to the center of the viewport:

```python
>>> d.execute_script("window.scrollBy(0, -150);")
```

That's all for now; I suspect I'll continue to run into other types of element scrolling issues when using WebDriver, so this post may become the first in a series!

