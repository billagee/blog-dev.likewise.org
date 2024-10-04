Title: OpenSSL oneliner to print a remote server's cert validity dates
Date: 2013-07-31 18:27
Tags: OpenSSL, Bash
Slug: openssl-oneliner-to-print-a-remote-servers-cert-validity-dates

Today I wanted to check the notBefore and notAfter validity dates of an SSL cert installed on a remote server.

I immediately wondered if there was an easy way to use the <a target="_blank" href="http://www.openssl.org/docs/apps/openssl.html">OpenSSL command line tool</a> to accomplish this.

And there is - you just have to pass the output of <tt>openssl s_client</tt> to <tt>openssl x509</tt>, and away you go:

```
echo |\
  openssl s_client -connect www.google.com:443 2>/dev/null |\
  sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' |\
  openssl x509 -noout -subject -dates
```

That command should print the subject, notBefore, and notAfter dates of the certificate used by www.google.com:

```
subject= /C=US/ST=California/L=Mountain View/O=Google Inc/CN=www.google.com
notBefore=Jul 12 08:56:36 2013 GMT
notAfter=Oct 31 23:59:59 2013 GMT
```

I picked up the specifics of how to do this over at the very useful <a target="_blank" href="http://www.madboa.com/geek/openssl/">OpenSSL Command-Line HOWTO</a> site. It's worth reading in depth.

