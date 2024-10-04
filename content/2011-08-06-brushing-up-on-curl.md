Title: Brushing up on cURL
Date: 2011-08-06T09:51:00-07:00
Tags: curl
Slug: brushing-up-on-curl
Alias: /2011/08/brushing-up-on-curl.html

The <a target="_blank" href="http://curl.haxx.se/">curl command line tool</a> is a great addition to your toolbox when working on web-related testing projects.

It's difficult to add up all the ways curl is useful for testing tasks. Here's an attempt at documenting a few simple scenarios.

### Installing the curl command line tool

OSX ships with a copy of curl pre-installed, so Mac users have nothing to do here.

Linux distributions typically ship with curl or make it very easy to install it with a package management system.

On Windows, you can download a binary release of curl to get up and running quickly - I recommend using cygwin, or I've also had good luck with the curl 7.21.7 build found in the "Win32 Generic" section (provided by Günter Knauf) at the bottom of this page:

<a target="_blank" href="http://curl.haxx.se/download.html">http://curl.haxx.se/download.html</a>

### To make a GET request for a file, and save a local copy:

Sometimes it's useful to fetch a file from a server and compare it (or its md5 hash) to a known file, to make sure you received the right content - so curl to the rescue:

    :::bash
    curl --remote-name http://www.w3schools.com/images/pulpit.jpg

The ```--remote-name``` option tells curl to save a local copy of the file using the same name found on the remote server.

After running the command above, a copy of pulpit.jpg should appear in your current local directory.

### Using the --silent option for minimal output

You most likely noticed the progress output that curl prints when the command above is run.

The handy --silent option allows one to suppress that information:

    :::bash
    curl --silent --remote-name http://www.w3schools.com/images/pulpit.jpg

### Using curl's --write-out option to print extra information about a request

curl's ```--write-out``` option is extremely useful. It allows you to specify extra information to print, using special variables.

For example, to print the HTTP response code of your request, you use the ```http_code``` variable.

You must enclose the variables in ```%{}```.  For example:

    :::bash
    --write-out %{http_code}

Here's a real example of using the option. Note the ```200``` response code that curl prints:

    :::bash
    curl --write-out %{http_code} \
        --silent --remote-name http://www.w3schools.com/images/pulpit.jpg
    200

You can also pass multiple variables to ```--write-out```, and create your own format string, so that it's easy to tell what each value represents.

You can even use newlines in your format string, using ```\n``` as shown here:

    :::bash
    --write-out "Response code: %{http_code}\nTotal time: %{time_total}"

Example output from the above command:

    :::bash
    curl --write-out "Response code: %{http_code}\nTotal time: %{time_total}" \
        --silent --remote-name http://www.w3schools.com/images/pulpit.jpg
    
    Response code: 200
    Total time: 0.797

### Using curl to test redirects

```--write-out``` can also be used to make sure that a URL that should redirect the client is successfully doing so.

Even better, you can see what URL the server is telling you to redirect to.

As an example, the URL *http://www.gmail.com/* currently redirects to *http://mail.google.com/*.

To check that on the command line, you can use the ```redirect_url``` variable with ```--write-out```:

    :::bash
    curl --write-out \
        "\nResponse code: %{http_code}\nRedirect URL: %{redirect_url}\n" \
        http://www.gmail.com/

Running the above command should result in this output:

    :::bash
    <HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
    <TITLE>301 Moved</TITLE></HEAD><BODY>
    <H1>301 Moved</H1>
    >The document has moved
    <A HREF="https://mail.google.com/mail/">here</A>.
    </BODY></HTML>
    
    Response code: 301
    Redirect URL: https://mail.google.com/mail/

### Using --include and --verbose

More verbose ways of scrutinizing the server's response are available, via the ```--include``` and ```--verbose``` options.

```--include``` prints all the headers sent by the server in response to the request. Very cool!

    :::bash
    curl --include http://www.gmail.com/
    
    HTTP/1.1 301 Moved Permanently
    Location: https://mail.google.com/mail/
    Content-Type: text/html; charset=UTF-8
    X-Content-Type-Options: nosniff
    Date: Tue, 16 Aug 2016 13:05:21 GMT
    Expires: Thu, 15 Sep 2016 13:05:21 GMT
    Server: sffe
    Content-Length: 226
    X-XSS-Protection: 1; mode=block
    Cache-Control: public, max-age=2592000
    Age: 364604
    
    <HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
    <TITLE>301 Moved</TITLE></HEAD><BODY>
    <H1>301 Moved</H1>
    The document has moved
    <A HREF="https://mail.google.com/mail/">here</A>.
    </BODY></HTML>

```--verbose``` expands on that by also printing the headers sent by you (the client) and some other diagnostic info:

    :::bash
    curl --verbose http://www.gmail.com/
    
    *   Trying 216.58.195.229...
    * Connected to www.gmail.com (216.58.195.229) port 80 (#0)
    > GET / HTTP/1.1
    > Host: www.gmail.com
    > User-Agent: curl/7.48.0
    > Accept: */*
    >
    < HTTP/1.1 301 Moved Permanently
    < Location: https://mail.google.com/mail/
    < Content-Type: text/html; charset=UTF-8
    < X-Content-Type-Options: nosniff
    < Date: Mon, 15 Aug 2016 01:39:32 GMT
    < Expires: Wed, 14 Sep 2016 01:39:32 GMT
    < Server: sffe
    < Content-Length: 226
    < X-XSS-Protection: 1; mode=block
    < Cache-Control: public, max-age=2592000
    < Age: 493768
    <
    <HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
    <TITLE>301 Moved</TITLE></HEAD><BODY>
    <H1>301 Moved</H1>
    The document has moved
    <A HREF="https://mail.google.com/mail/">here</A>.
    </BODY></HTML>
    * Connection #0 to host www.gmail.com left intact

### To sum up:

This only scratches the surface of what is possible with curl. For more information, see:

<a href="http://curl.haxx.se/docs/manpage.html" target="_blank">http://curl.haxx.se/docs/manpage.html</a>

<a href="http://curl.haxx.se/docs/httpscripting.html" target="_blank">http://curl.haxx.se/docs/httpscripting.html</a>
