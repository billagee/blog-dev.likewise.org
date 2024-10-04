Title: Using 7zip in lieu of GNU tar on the command line
Date: 2014-03-25 21:55
Tags: 
Slug: using-7zip-in-lieu-of-gnu-tar-on-the-command-line

These days I'm accustomed to having the **7z** command available on Unix-like systems (thanks to the <a target="_blank" href="http://p7zip.sourceforge.net/">p7zip</a> project).

On top of that, 7zip is always one of the first utils I install on any Windows machine I work with.

So as an exercise in cross-platform style (or just for the heck of it), I sometimes use 7z instead of tar when working with archive files.

Here's a list of basic file archiving tasks, with a comparison of how each is tackled with GNU tar versus 7zip:

Compress and archive a directory, preserving paths
--------------------------------------------------
Imagine you want to compress and archive the directory "foo/" and its contents:
```
foo/
foo/level1/
foo/level1/level2/
foo/level1/level2/hi.txt
```

### tar
With GNU tar you can create such an archive with:
```
tar czf foo.tar.gz foo
```

### 7zip
To create a similar archive with 7zip (specifically, the **7z**, **7z.exe**, or **7za.exe** binaries), use the **7z a** command:
```
7z a foo.7z foo
```

Interestingly, with 7zip you can also omit the name of the archive file to create; this results in an archive file with a .7z extension, otherwise named after the archived dir:
```
7z a foo
```

Also note that the 7z format is the default archive type created, unless you specify an alternative type with the **-t** option.

Extract an archive, recreating paths
------------------------------------
This is simple enough, and quite similar between the two tools:

### tar
```
tar xf foo.tar.gz
```

### 7zip
```
7z x foo.7z
```

Note that the **7z e** command (which you may discover before **7z x**) will ignore the directory structure inside the archive, and extract every file and dir into your current dir. That behavior will come in handy for a later task.

Determine whether a given file is in the archive
------------------------------------------------

### 7zip

With 7z, this is pretty straightforward when using the **7z l** (list) command combined with the **-r** (recurse) option:
```
7z l -r foo.7z hi.txt
```

### tar

With GNU tar, there are several ways to approach this task.

You can pass the full path to the file to **tar tf**, along with the archive file name, and tar will error out if there's no match inside the archive:
```
tar tf foo.tar.gz foo/level1/level2/hi.txt
```

Or, if the original, unarchived dir structure is still present on disk, you can pass it to **tar d** (--diff), and tar will compare the archive with the unarchived dir:
```
tar df foo.tar.gz foo/level1/level2/hi.txt
```

Note that BSD tar does not appear to have anything like the d/--diff option.

After all is said and done, piping **tar t** output to grep may be the most suitable option here:
```
tar tf foo.tar.gz | grep hi.txt
```

Extract a single file from an archive into the current dir
----------------------------------------------------------

This scenario is interesting, in that the task is noticeably simpler when using 7zip.

Let's say you want to extract **hi.txt** from the archive, placing the file in your current dir.

### 7zip
With 7z, you can use **7z e -r** to retrieve the file (in this case **hi.txt**), even if it's several levels down in the archive:
```
7z e -r foo.7z hi.txt
```

### tar
With GNU or BSD tar you'll need to count how many levels deep in the archive's dir hierarchy your file lives, and pass that number of leading dirs to remove from the output, using **--strip-components**:
```
tar --strip-components=3 -xf foo.tar.gz foo/level1/level2/hi.txt
```

