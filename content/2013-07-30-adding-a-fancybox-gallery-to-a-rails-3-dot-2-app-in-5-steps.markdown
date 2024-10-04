Title: Adding a fancybox gallery to a Rails 3.2 app in 5 steps
Date: 2013-07-30 22:51
Tags: Rails, Fancybox, Railscasts, jQuery
Slug: adding-a-fancybox-gallery-to-a-rails-3-dot-2-app-in-5-steps

I was interested in seeing how quickly one can add a lightbox gallery to a Rails app nowadays.

As it happens, there's really not much to it, especially when using the <a target="_blank" href="https://github.com/hecticjeff/fancybox-rails">fancybox-rails gem</a>.

This post describes how to bring up an existing image viewer app (the "gallery-after" app from the github repo for <a target="_blank" href="http://railscasts.com/episodes/381-jquery-file-upload">Railscasts episode # 381</a>), then add fancybox support to it.

Here's what the end result will look like:

![Fancybox Screenshot]({attach}images/fancybox.png)

Setting up a Rails app that displays images
-------------------------------------------

- First order of business: We need a Rails app that displays images so we can fancybox it up!

Rather than create one from scratch, let's grab an existing app.

As mentioned above, one of the apps from Railscasts episode # 381 will do nicely. To get the files from github:

```
git clone https://github.com/railscasts/381-jquery-file-upload.git
```

When that completes, cd into the "gallery-after" app dir we'll be using:

```
cd 381-jquery-file-upload/gallery-after/
```

- Note that the app depends on rmagick, and rmagick depends on ImageMagick.

So next, install imagemagick. On OS X, you can use this homebrew command:

```
brew install imagemagick
```

On Linux distributions, ImageMagick will more than likely be available in your package management system.

- This is the point where you'd normally do nothing more than type <tt>bundle</tt>, and the app would be usable in short order.

But I ran into a snag:

On my system, trying to 'bundle install' failed on the rmagick gem, during extension compilation, with this error:

```
"An error occurred while installing rmagick (2.13.1), and Bundler cannot continue."
```

The fix:

I modified <tt>gallery-after/Gemfile</tt> to make bundler fetch rmagick 2.13.2 - a version of the gem that resolves the install issue:

```
# In gallery-after/Gemfile, specify rmagick "2.13.2":
  gem 'rmagick', '2.13.2'
```

Then:

```
bundle
```

...and the installation of rmagick should succeed.

Side note: Near as I could tell, the rmagick problem is due to an incompatibility between rmagick 2.13.1 and the latest version of ImageMagick available via homebrew.

And the <tt>gallery-after/Gemfile.lock</tt> comes configured to install rmagick version 2.13.1, leading to the problem.

- After your 'bundle' command succeeds, configure your sqlite database:

```
bundle exec rake db:setup
```

- Launch the app:

```
bundle exec rails s
```

Point a browser at localhost:3000 and drag-and-drop some image files into your browser window.

This will insert the images into your DB, which will come in handy later so we have something to view in fancybox.


Adding fancybox-rails to the app
--------------------------------

- Stop the running app, and edit your Gemfile. Add the fancybox-rails gem:

```
# In Gemfile
gem 'fancybox-rails'
```

Then tell bundler to install it:

```
bundle
```

- Next, per the steps on the <a target="_blank" href="http://hecticjeff.net/fancybox-rails/">fancybox-rails README</a>, add fancybox to your app's main JavaScript file:

Edit <tt>app/assets/javascripts/application.js</tt> and add the fancybox line just under the jquery require statement that will already be in the file:

```
//= require jquery
//= require fancybox
```

- Next, take care of the fancybox CSS file.

Edit <tt>app/assets/stylesheets/application.css</tt> and add the fancybox line above the require_tree line:

```
/*
 *= require_self
 *= require fancybox
 *= require_tree .
 */
```

- Now, edit <tt>app/assets/javascripts/paintings.js.coffee</tt>, and at the end of the file, add the code to initialize fancybox for links that have the class value <tt>grouped_elements</tt>:

```
jQuery ->
  $("a.grouped_elements").fancybox({
      'transitionIn'  :   'elastic',
      'transitionOut' :   'elastic',
      'speedIn'       :   600,
      'speedOut'      :   200,
      'overlayShow'   :   false
  });
```

- Almost done!

The last step is to add a gallery link to the paintings partial, where the link's <tt>class</tt> attribute value is set to the "grouped_elements" identifier we added to <tt>paintings.js.coffee</tt>.

Also, the gallery link's <tt>rel</tt> attribute value needs to be defined; in fancybox <a target="_blank" href="http://fancybox.net/howto">elements with the same rel value are considered part of the same gallery</a>, which enables flipping between the images without having to close the fancybox viewer.

To take care of those steps, edit <tt>app/views/paintings/_painting.html.erb</tt> and insert the "view in gallery" link shown below, above the existing edit/remove links:

```
   <div class="actions">
<%# This is the line to add: -%>
     <%= link_to "view in gallery", painting.image_url, { :class => "grouped_elements", :rel => "zomg_awesome_images" } %> |
     <%= link_to "edit", edit_painting_path(painting) %> |
     <%= link_to "remove", painting, :confirm => 'Are you sure?', :method => :delete %>
```

That's all there is to it.

When you restart your Rails app, each image the app displays should now have a "view in gallery" link below it that launches fancybox, with navigation controls to skip from image to image!

Not too shabby for just a handful of extra lines of code.

