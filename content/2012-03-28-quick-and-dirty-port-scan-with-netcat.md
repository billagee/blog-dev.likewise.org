Title: Quick and dirty port scan with netcat
Date: 2012-03-28T22:01:00-07:00
Tags: netcat, Perl
Slug: quick-and-dirty-port-scan-with-netcat
Alias: /2012/03/quick-and-dirty-port-scan-with-netcat.html

<a target="_blank" href="http://nc110.sourceforge.net/">netcat</a> (or "nc" on the command line) is a useful tool for many reasons.

One common test automation task I've found it handy for is polling a port, waiting for a service to start responding.

While there are many ways to do that, using nc is a handy way to get it done.

And it's easy to script - here's a short Perl snippet showing how to wrap nc to poll a port on a host:

<script src="https://gist.github.com/2233382.js"> </script>
