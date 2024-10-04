Title: Using cURL to Access Bugzilla's XML-RPC API
Date: 2013-09-17 14:43
Tags: curl
Slug: using-curl-to-access-bugzillas-xml-rpc-api

Today I had the chance to briefly explore <a target="_blank" href="https://bugzilla.readthedocs.io/en/latest/api/index.html">Bugzilla's API</a>.

I used curl to experiment with the XML-RPC API a bit - in the end I just scratched the surface of what's possible, but it was interesting nonetheless.

Here are a few examples of things you can do:

Hello World
-----------
A nice hello world example for the Bugzilla API is to query your Bugzilla server for its version, as <a target="_blank" href="http://pivotallabs.com/setting-up-and-troubleshooting-the-bugzilla-integration-in-tracker/">documented a while back</a> on the Pivotal Labs blog.

This example uses Mozilla's public server at https://bugzilla.mozilla.org.

Note the use of the <tt>Bugzilla.version</tt> methodName, and the way the output is piped to tidy for indentation and pretty-printing:

```
curl --silent --insecure \
  https://bugzilla.mozilla.org/xmlrpc.cgi \
  -H "Content-Type: text/xml" \
  -d "<?xml version='1.0' encoding='UTF-8'?><methodCall><methodName>Bugzilla.version</methodName> <params> </params> </methodCall>" \
  | tidy -xml -indent -quiet
```

That command should output:

```
<?xml version="1.0" encoding="utf-8"?>
<methodResponse>
  <params>
    <param>
      <value>
        <struct>
          <member>
            <name>version</name>
            <value>
              <string>4.2.6+</string>
            </value>
          </member>
        </struct>
      </value>
    </param>
  </params>
</methodResponse>
```

XPath expressions
-----------------
To reduce visual clutter, and select specific elements, it's handy to use an XPath expression to extract values you're interested in.

For example, to select the version value from the above query, you can pipe curl's output to the xpath command-line program (which appears to ship with OS X):

```
curl --silent --insecure \
  https://bugzilla.mozilla.org/xmlrpc.cgi \
  -H "Content-Type: text/xml" \
  -d "<?xml version='1.0' encoding='UTF-8'?><methodCall><methodName>Bugzilla.version</methodName> <params> </params> </methodCall>" \
  | xpath '//name[contains(text(), "version")]/../value/string/text()'
```

That command should print:

```
Found 1 nodes:
-- NODE --
4.2.6+
```

Getting bug data
----------------

To take things a step further, here's another example - looking up the summary and creation_time values of a given bug ID.

The Bug.get method makes this possible, and an XPath expression that prints the text of the bug summary and creation_time values slims down the blob of XML returned by the API call.

This example will return information on bug 9940. Note how the bug ID is passed in the params list:

```
curl --silent --insecure \
  https://bugzilla.mozilla.org/xmlrpc.cgi \
  -H "Content-Type: text/xml" \
  -d "<?xml version='1.0' encoding='UTF-8'?><methodCall><methodName>Bug.get</methodName> <params><param><value><struct><member><name>ids</name><value>9940</value></member></struct></value></param> </params> </methodCall>" \
  | xpath '//name[contains(text(), "summary")]/../value/string/text() | //name[contains(text(), "creation_time")]/../value/dateTime.iso8601/text()'
```

The result should show you bug 9940's creation date and awesome summary:

```
Found 2 nodes:
-- NODE --
19990715T20:08:00-- NODE --
Bugzilla should have a party when 1,000,000 bugs get entered
```

Party like it's 1999!

Note that if your bugzilla server has authentication enabled, logging in via the API is also possible. A cookie can be obtained and used in subsequent requests.

