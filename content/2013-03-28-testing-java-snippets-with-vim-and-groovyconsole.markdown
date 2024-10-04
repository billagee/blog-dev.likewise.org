Title: Testing Java snippets with Vim and GroovyConsole
Date: 2013-03-28 07:54
Categories: Java, Vim
Slug: testing-java-snippets-with-vim-and-groovyconsole

For instructional purposes (either when experimenting on your own, or when demonstrating code to others) it's always useful to be able to run snippets of code in a <a target="_blank" href="http://en.wikipedia.org/wiki/REPL">REPL</a>, or a similar environment allowing fast turnaround in the edit/compile/run cycle.

When using Java, other IDEs offer ways to get REPL-like behavior, but what if you don't want to use a traditional Java IDE?

Perhaps you just want to demonstrate a trivial bit of code without much overhead.

In that situation, a couple of nice options for Java are:

- Use GroovyConsole as a Java REPL
- Edit your code in Vim, and compile and run it without leaving the editor

### 1.  Using GroovyConsole

If you're on a Mac, GroovyConsole can be installed via the homebrew groovy formula (or, just get it from <a target="_blank" href="http://groovy.codehaus.org">http://groovy.codehaus.org</a>):

<pre>brew install groovy</pre>

Launch GroovyConsole with this command:

<pre>groovyConsole</pre>

Then simply type in a code snippet and run it with &lt;Command-R&gt; (or on Windows, &lt;CTRL-R&gt;):

![groovyConsole screenshot]({attach}images/groovyConsole.png)

### 2.  Using Vim as an improvised Java IDE

![foo dot java]({attach}images/vim/foo-dot-java.png)

First, launch vim and write a small program - for example, Foo.java:

![running javac from vim]({attach}images/vim/foo-javac.png)

Then, compile your program without leaving vim by passing the file open in your vim buffer to javac, using the <tt>:!</tt> command sequence and <tt>%</tt>

![ENTER prompt from vim]({attach}images/vim/foo-enter-to-continue.png)

If all goes well, you'll temporarily be dropped to the shell, with no visible errors, and get prompted to press ENTER to continue back to vim:

![running Foo.class in java]({attach}images/vim/java-foo.png)

Back in the editor, use <tt>:!java Foo</tt> to invoke the Java class file you just created with javac:

![Foo.class output]({attach}images/vim/output.png)

Finally, you'll see your program's output in the console.

For further fun, try compiling with <tt>javac -g %</tt>, then launch your class file with <tt>jdb Foo</tt> to debug your program from within vim.

Also, you might consider taking the <a target="_blank" href="http://www.vim.org/scripts/script.php?script_id=1785">javacomplete omni-completion plugin</a> for a spin.

