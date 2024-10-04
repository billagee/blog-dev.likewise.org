Title: Switching from Octopress to Pelican
Date: 2016-08-23 07:00
Tags: Pelican
Slug: switching-from-octopress-to-pelican

### Or: What we blog about when we blog about blogs

### 🐙 ➡️  🐍 

This post is the story of how I switched the underlying framework for this blog from <a target="_blank" href="http://octopress.org/">Octopress</a> to <a target="_blank" href="http://blog.getpelican.com/">Pelican</a>.

And I added a side quest: Like many Octopress users, I grew fond of the default Octopress theme, and wanted to keep it after moving to Pelican.

Keeping the Octopress theme turned out to be easy; the pelican-octopress-theme github repo was what I needed:

- <a target="_blank" href="https://github.com/duilio/pelican-octopress-theme">https://github.com/duilio/pelican-octopress-theme</a>

And for other tips, Google revealed blog posts from other folks who made the Octopress-to-Pelican switch over the years. Trip reports I referred to were:

- <a target="_blank" href="https://jakevdp.github.io/blog/2013/05/07/migrating-from-octopress-to-pelican/">https://jakevdp.github.io/blog/2013/05/07/migrating-from-octopress-to-pelican/</a>
- <a target="_blank" href="http://themodernscientist.com/posts/2013/2013-06-02-my_octopelican_python_blog/">http://themodernscientist.com/posts/2013/2013-06-02-my_octopelican_python_blog/</a>
- <a target="_blank" href="http://jhshi.me/2015/10/11/migrating-from-octopress-to-pelican/">http://jhshi.me/2015/10/11/migrating-from-octopress-to-pelican/</a>

## The plan

First off, after <a target="_blank" href="http://docs.getpelican.com/">reading the docs</a>, I wrote down the steps I assumed would be involved with the move; here they are:

1. Create and activate a virtualenv, then use pip to install pelican
1. Use the ```pelican-quickstart``` util to set up a barebones Pelican blog, as a starting point for the move
1. Get used to launching a dev server to preview changes
1. Apply the pelican-octopress-theme to the barebones blog
1. Bring my old blog's CSS and sidebar customizations into pelican-octopress-theme
1. Create a <a target="_blank" href="https://github.com/billagee/blog.likewise.org">public github repo</a> containing the work so far
1. Copy the old Markdown post files and images from my Octopress dir to my pelican repo
1. Edit posts as needed to get them to display properly
1. Back up the contents of my existing blog's s3 bucket (for easy rollback if the first deploy doesn't go smoothly)
1. Publish the new files to s3!

## The reality

Based on the outline above, here's what actually happened when I started carrying out the plan:

1. #### Installing pelican
    
    For this step I set up a new virtualenv and installed the pelican and markdown packages:
    
        :::bash
        mkdir blog.likewise.org
        cd blog.likewise.org/
        virtualenv env
        . env/bin/activate
        pip install pelican markdown
    
    For the record, I was using OS X, Python 2.7.12 from Macports, and Pelican 3.6.3.
    
1. #### Running ```pelican-quickstart```
    
    This part of the process went smoothly. The quickstart util didn't bring up any surprises, and produced the files that became the blog you're reading now.
    
    Here's a log of the input I gave ```pelican-quickstart``` to bring up a site with a dev server script, Makefile, and s3 publishing support:
    
        :::bash
        pelican-quickstart
        
        > Where do you want to create your new web site? [.]
        > What will be the title of this web site? Bill Agee's blog
        > Who will be the author of this web site? Bill Agee
        > What will be the default language of this web site? [en]
        > Do you want to specify a URL prefix? e.g., http://example.com   (Y/n) n
        > Do you want to enable article pagination? (Y/n) n
        > What is your time zone? [Europe/Paris] America/Los_Angeles
        > Do you want to generate a Fabfile/Makefile to automate generation and publishing? (Y/n) Y
        > Do you want an auto-reload & simpleHTTP script to assist with theme and site development? (Y/n)
        > Do you want to upload your website using FTP? (y/N)
        > Do you want to upload your website using SSH? (y/N)
        > Do you want to upload your website using Dropbox? (y/N)
        > Do you want to upload your website using S3? (y/N) y
        > What is the name of your S3 bucket? [my_s3_bucket] blog.likewise.org
        > Do you want to upload your website using Rackspace Cloud Files? (y/N)
        > Do you want to upload your website using GitHub Pages? (y/N)
        Done. Your new project is available at /Users/bill/github/billagee/blog.likewise.org
    
1. #### Bringing up a dev server to preview changes
    
    This was super easy. Assuming you answered yes to the auto-reload & simpleHTTP question in ```pelican-quickstart```, just run ```make devserver```.
    
    Then point your web browser at ```localhost:8000``` to browse your site.
    
    To stop your dev server, run ```make stopserver```.
    
1. #### Apply pelican-octopress-theme to the demo blog
    
    At this point I paused to see what the docs had to say about <a target="_blank" href="http://docs.getpelican.com/en/3.6.3/settings.html#themes">how to use themes in Pelican</a>.
    
    To try out the stock pelican-octopress-theme, first clone its repo:
    
        :::bash
        git clone https://github.com/duilio/pelican-octopress-theme.git \
            ~/github/duilio/pelican-octopress-theme
    
    Then install it in your site with the ```pelican-themes``` util:
    
        :::bash
        pelican-themes --install ~/github/duilio/pelican-octopress-theme
    
    There's one more step - to make sure the dev server can find the theme, edit the ```develop_server.sh``` file in your pelican dir, and place the ```--theme-path``` option and value in the ```PELICANOPTS``` variable:
    
        :::bash
        # In develop_server.sh - replace the empty PELICANOPTS= var if it's present:
        PELICANOPTS="--theme-path ~/github/duilio/pelican-octopress-theme"
    
    This is a good time to make the same change in the ```Makefile``` in the root of your site, since you'll be needing it there too (note that the double quotes around the value are left out):
    
        :::Makefile
        PELICANOPTS=--theme-path ~/github/billagee/pelican-octopress-theme
    
    Restart your dev server after making those changes, and reload the site in your browser - you should then see the Octopress theme in place:
    
        :::bash
        make stopserver && make devserver
    
1. #### Making a test post
    
    At this point I added a new step to the original plan: Learning how to create a post.
    
    To do that using Markdown (adapted <a target="_blank" href="http://docs.getpelican.com/en/3.6.3/content.html">from the content docs</a>), you can cat out a post file to disk like so, if you're in your site's root dir:
    
        :::bash
        # Again, this assumes your current working dir is your blog's root dir:
        cat > content/2016-08-20-my-test-post.md << EOL
        Title: My title
        Date: 2016-08-20 12:30
        Category: Python
        Tags: pelican, publishing
        Slug: my-test-post
        Authors: Your Name Here
        Summary: Short version for index and feeds
        
        This is the content of my test post.
        EOL
    
1. #### Bring my old blog's color and sidebar customizations into pelican-octopress-theme
    
    This is, of course, an optional step, but I wanted to change the header background color of the Octopress theme, and rearrange the sidebar.
    
    This required a bit of tinkering, but it wasn't too bad.
    
    To change the header background color in pelican-octopress-theme, I first made <a target="_blank" href="https://github.com/billagee/pelican-octopress-theme">my own fork</a> of <a target="_blank" href="https://github.com/duilio/pelican-octopress-theme">the original repo</a>.
    
    Then, I cloned my fork, and changed the ```$header-bg``` value in the SASS file where it lives: <a target="_blank" href="https://github.com/billagee/pelican-octopress-theme/blob/master/sass/base/_theme.scss">sass/base/_theme.scss</a>
    
        :::sass
        //$header-bg: #333 !default; // default octopress gray
        $header-bg: #35206f !default; // likewise purple
    
    There's one more step required - recompiling the theme's SASS files using the ```compass``` util. To install sass and compass and update the theme with your changes, ```cd``` to the root of your pelican-octopress-theme fork, and:
    
        :::bash
        # Run this in your pelican-octopress-theme root dir
        gem install sass compass
        compass compile
    
1. #### Create a <a target="_blank" href="https://github.com/billagee/blog.likewise.org">public github repo</a> containing the work so far
    
    Not much to say here, except that you might be interested in the <a target="_blank" href="https://github.com/billagee/blog.likewise.org/blob/master/.gitignore">.gitignore</a> file I created before pushing my repo:
    
        :::bash
        *~
        ._*
        *.lock
        *.DS_Store
        *.swp
        *.out
        *.py[cod]
        output
        env
        srv.pid
        pelican.pid
    
    Omit the ```output``` dir from your .gitignore if you want to keep your generated site files under version control.
    
1. #### Copy the old Markdown post files from my Octopress dir to my pelican repo
    
    This is where things began to get real. I started by coping the post files from my ```sources/_posts``` Octopress dir to ```content/```. I then committed everything as-is before making edits.
    
    The first step was to convert the old Octopress post metadata, for example:
    
        :::markdown
        ---
        layout: post
        title: "Dockerized Ghostdriver Selenium Tests"
        date: 2016-02-14 00:23
        comments: true
        categories: Docker Linux Selenium WebDriver Automation PhantomJS Python Testing
        ---
    
    ...to the corresponding Pelican Markdown:
    
        :::markdown
        Title: Dockerized Ghostdriver Selenium Tests
        Date: 2016-02-14 00:23
        Tags: Docker, Linux, Selenium, WebDriver, Automation, PhantomJS, Python
        Slug: dockerized-ghostdriver-selenium-tests
    
    Note the addition of the ```Slug``` field, and replacing ```categories:``` with ```Tags```, since Pelican offers both categories AND tags. And Pelican tags seem akin to Octopress categories.
    
1. #### Edit posts as needed to get them to display properly
    
    I noticed a few indentation changes to existing code blocks in my posts were required to get them to display properly.
    
    In the end, I switched over to using code blocks prefixed with ```:::```, for syntax highlighting with <a target="_blank" href="http://docs.getpelican.com/en/3.6.3/content.html#syntax-highlighting">CodeHilite</a>. Here's an example:
    
    <script src="https://gist.github.com/billagee/b9bf022f1ffbc1c1d3e04e0c49c18ac5.js"></script>
    
1. #### Converting Octopress image tags
    
    There was another extra step required to get images in old posts to display - moving Octopress Markdown posts to Pelican means embedded images that use the Octopress ```{% img %}``` tag won't carry over directly without edits (or the <a target="_blank" href="https://github.com/jakevdp/pelican-plugins/tree/liquid_tags/liquid_tags">liquid_tags Pelican plugin</a>).
    
    I didn't have too many images in my old posts, so I just replaced my old Octopress image tags, such as:
    
        :::markdown
        {% img /images/fancybox.png 'fancybox screenshot' %}
    
    ...with the Pelican attach syntax:
    
        :::markdown
        ![Fancybox Screenshot]({attach}images/fancybox.png)
    
    This was also the point when I finished copying all the image files from my old Octopress dir (```source/images/```) into my Pelican blog's ```content/images/``` dir.
    
1. #### Back up the contents of my existing s3 bucket before copying any new files to the bucket
    
    Not much to say here. ```s3cmd sync``` was my means of doing this.
    
1. #### Publish the new files to s3!
    
    With your AWS credentials in ```~/.s3cfg```, just set your s3 bucket's name in your Pelican dir's ```Makefile```, in the ```S3_BUCKET``` variable.
    
    Then, to publish your changes to your s3 bucket:
    
        :::bash
        make clean
        make s3_upload
    
1. #### Manually fixing the ```Content-Type``` value for main.css
    
    I ran into a hiccup here - after publishing my files to s3, the MIME type guessing done during the upload apparently didn't work, so my main.css file was served by s3 as text/plain.
    
    This resulted in the published copy of the blog in s3 displaying without CSS being applied; so, the appearance of the blog was totally broken in all browsers I tried. Oops.
    
    Presumably this will only affect you if you're publishing to s3 like me; I didn't try deploying with Dropbox or the other options.
    
    I worked around the problem by using the AWS console to manually change the Content-Type header value S3 serves up for my ```main.css``` file. (I still need to find a real fix for this, or at least a way of doing it with ```s3cmd```.)
    
    Steps for the fix were:
    
    - After ```make s3_upload``` completes, log in to the AWS s3 console.
    
    - In the UI, navigate to: *All Buckets > /YOUR_BUCKET/theme/css*
    
    - Right-click ```main.css```, and view its properties
    
    - Under "Metadata", set the Content-Type key to ```text/css``` and save.
    
1. #### Using the pelican-alias plugin to create .html aliases to posts
    
    I'd forgotten that my very oldest Octopress posts were actually raw HTML migrated from Blogger years ago - long ago I jammed that content into Markdown files, and each Markdown file contained one massive, single-line ```<div>``` exported from Blogger.
    
    Ugh! I couldn't let that stand, so I took the time to convert those old HTML posts to proper Markdown.
    
    I then realized a few of those old Blogger-era HTML posts were still showing up in Google results, with their original .html extensions (which Pelican and Octopress don't create).
    
    In the Octopress blog I'd resorted to creating s3 aliases for those old posts at publish time, in the bash script I used to upload everything with s3cmd.
    
    That resulted in posts whose URLs ended in ```2012-08-foo/``` getting matching ```2012-08-foo.html``` siblings, in case someone visited the old Blogger URL.
    
    In Pelican, you can use the <a target="_blank" href="https://pypi.python.org/pypi/pelican-alias">pelican-alias plugin</a> to create .html aliases for posts, which worked fine for me. See that plugin's docs for more info.
    
    For more it boiled down to installing and activating the plugin, then adding an extra bit of metadata to the ancient posts that needed an .html alias:
    
        :::Markdown
        Alias: /2011/07/selenium-2-net-test-drive.html
    
1. #### Google Analytics
    
    To set up Google Analytics, I put my GA ID in the ```pelicanconf.py``` file in the site's root dir, in the ```GOOGLE_ANALYTICS``` var.
    
1. #### Modifying the order of items in the Octopress theme sidebar
    
    My old blog had some custom tweaks to the sidebar; preserving those (and adding some new ones) was mainly a matter of editing this file in my pelican-octopress-theme fork:
    
    ```pelican-octopress-theme/templates/_includes/sidebar.html```
    
    The <a target="_blank" href="https://github.com/billagee/pelican-octopress-theme/commits/master">commit history for my pelican-octopress-theme</a> fork tells the full story of the sidebar.
    
1. #### Github sidebar fix
    
    Either due to a bug in the theme, or as a result of my sidebar tweaks, the Github chunk of the sidebar was refusing to fetch the list of my github repos.
    
    To get that working, I made this JS tweak in my fork's copy of ```pelican-octopress-theme/templates/_includes/github.html``` - namely pulling in jQuery.
    
    This seems rather...not great, but it works for now:
    
        :::diff
             {% if GITHUB_SHOW_USER_LINK is defined %}
               <a href="https://github.com/{{ GITHUB_USER }}">@{{ GITHUB_USER }}</a> on GitHub
             {% endif %}
        +    <script src="https://code.jquery.com/jquery-3.1.0.min.js" integrity="sha256-cCueBR6CsyA4/9szpPfrX3s49M9vUU5BgtiJj06wt/s=" crossorigin="anonymous"></script>
             <script type="text/javascript">
        -      $.domReady(function(){
        +      $(document).ready(function(){
                   if (!window.jXHR){
                       var jxhr = document.createElement('script');
                       jxhr.type = 'text/javascript';
    

## Whew

That's all for now, I suppose! This concludes my first Pelican post.
