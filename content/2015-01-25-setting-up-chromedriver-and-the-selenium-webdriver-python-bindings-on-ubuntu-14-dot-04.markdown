Title: Setting Up ChromeDriver and the Selenium-WebDriver Python bindings on Ubuntu 14.04
Date: 2015-01-25 01:55
Tags: Selenium, WebDriver, Automation, Chrome, Python, Testing
Slug: setting-up-chromedriver-and-the-selenium-webdriver-python-bindings-on-ubuntu-14-dot-04

This post documents how to set up an Ubuntu 14.04 64-bit machine with everything you need to develop automated tests with <a href="http://docs.seleniumhq.org/docs/03_webdriver.jsp">Selenium-WebDriver</a>, Google Chrome, and <a href="https://sites.google.com/a/chromium.org/chromedriver/">ChromeDriver</a>, using the Python 2.7 release that ships with Ubuntu.

These steps might be useful to someone in the near term, and perhaps in the future this post could make for an interesting time capsule - remembering the WebDriver that was!

All steps assume you've just booted a fresh Ubuntu 14.04 64-bit machine and are at the command prompt:

### 1. Download and install the latest Google Chrome release

    :::bash
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    
    sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb

### 2. Download and install the latest amd64 chromedriver release

Here we use wget to fetch the version number of the latest release, then plug the version into another wget invocation in order to fetch the chromedriver build itself:

    :::bash
    LATEST=$(wget -q -O - http://chromedriver.storage.googleapis.com/LATEST_RELEASE)
    
    wget http://chromedriver.storage.googleapis.com/$LATEST/chromedriver_linux64.zip

Symlink chromedriver into /usr/local/bin/ so it's in your PATH and available system-wide:

    :::bash
    unzip chromedriver_linux64.zip && sudo ln -s $PWD/chromedriver /usr/local/bin/chromedriver

### 3. Install pip and virtualenv

Using virtualenv allows you to install the Selenium Python bindings (and any other Python modules you might want) into an isolated environment, rather than the global packages dir, which (among other benefits) can help make your test environment easily reproducible on other machines:

    :::bash
    $ python -V
    Python 2.7.6
    
    $ sudo apt-get install python-pip
    
    $ sudo pip install virtualenv

### 4. Create a dir in which to install your virtualenv environment, and install and activate a new env

More documentation on what's being done here is available in the <a href="https://virtualenv.pypa.io/en/latest/">virtualenv docs</a>.

    :::bash
    mkdir mytests && cd $_
    
    virtualenv env
    
    source env/bin/activate

### 5. Install the Selenium bindings for Python in your virtualenv

    :::bash
    $ pip install selenium
    Collecting selenium
      Downloading selenium-2.44.0.tar.gz (2.6MB)
          100% |################################| 2.6MB 1.8MB/s 
          Installing collected packages: selenium
            Running setup.py install for selenium
            Successfully installed selenium-2.44.0

### 6. Launch Python in interactive mode, and briefly ensure you can launch a browser with ChromeDriver

Once the browser is open, navigate to www.google.com and print the document title:

    :::python
    $ python
    Python 2.7.6 (default, Mar 22 2014, 22:59:56) 
    [GCC 4.8.2] on linux2
    Type "help", "copyright", "credits" or "license" for more information.
    
    >>> from selenium import webdriver
    >>> d = webdriver.Chrome()
    >>> d.get("http://www.google.com/")
    >>> d.title
    u'Google'

That's all you need to get started - the next step I would suggest is to explore how to run
Selenium scripts using <a href="http://pytest.org/latest/">pytest</a> or <a href="https://docs.python.org/2/library/unittest.html">unittest</a>. That sounds like good territory to cover in a subsequent post, so perhaps I'll revisit it!
