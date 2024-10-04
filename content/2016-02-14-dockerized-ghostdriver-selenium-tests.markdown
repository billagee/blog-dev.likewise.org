Title: Dockerized Ghostdriver Selenium Tests
Date: 2016-02-14 00:23
Tags: Docker, Linux, Selenium, WebDriver, Automation, PhantomJS, Python
Slug: dockerized-ghostdriver-selenium-tests

(tl;dr: This post describes how to build a Docker image for running Python GhostDriver/PhantomJS tests in a container.)

### Background

In <a target="_blank" href="/2013/04/webdriver-testing-with-python-and-ghostdriver/">a previous post</a> I described how to set up
an environment to run automated Selenium WebDriver tests using the Ghostdriver/PhantomJS/Python web testing stack.

But these days, that's the sort of setup chore which you might consider Dockerizing, to avoid needless manual repetition of your setup recipe. (Because if your testing project gets any sort of traction at all, you'll inevitably need to replicate your environment on multiple machines.)

### A side note about reusing images

In this post we'll be building (from scratch) a Docker image capable of running GhostDriver tests, but in other situations, consider searching for an existing Docker image that does what you want - you might find one and be that much closer to your goal, whatever it may be!

To get started searching for images, see <a target="_blank" href="https://hub.docker.com/">https://hub.docker.com/</a>

## Outline

Down to business - let's build a Docker image.

This is an outline of the steps we'll be performing:

1. We'll create a Docker image which contains:
    * Ubuntu 14.04 (as the underlying base image)
    * PhantomJS
    * Python 2.7 and pip
    * The Selenium WebDriver Python bindings
    * A Python script that uses Ghostdriver and PhantomJS to perform a Google search test

1. We'll then use that image to run a container that:
    * Executes the Python Google search test script
    * Exits with an error if the test fails
    * Automatically removes the container when the test is complete

1. Next, we'll do some interactive work in a container, by:
    * Launching bash in a container (instead of the search test script)
    * In the containerized bash shell, we'll edit and manually run the modified test script

1. We'll create a Makefile to repeat the tasks above with fewer keystrokes.

1. Finally, we'll push the image to a public repo on Docker Hub.

Whew! Let's begin.

## 1. Creating your Docker image

- First, if you don't have Docker installed, follow the Docker Engine install guide for your OS, at:

<a target="_blank" href="https://docs.docker.com/engine/installation/">https://docs.docker.com/engine/installation/</a>

I'm using a Mac to write this guide - specifically, I have Docker Toolbox 1.8.2a installed on OS X 10.11.

- For the first step, create a new dir and cd into it:

        :::shell
        mkdir myimage && cd myimage

- Now create a file named ```Dockerfile``` in the ```myimage``` dir.

Inside the empty Dockerfile, paste these lines:

    :::shell
    FROM ubuntu:14.04

    # Install the phantomjs browser, Python, and the Python Selenium bindings
    RUN apt-get update && apt-get install -y \
            phantomjs \
            python2.7 \
            python-pip \
            && pip install selenium

    # Run a Ghostdriver demo script
    ENV my_test_script=google-search-test.py
    COPY ${my_test_script} /
    CMD "/${my_test_script}"

Notice the line ```ENV my_test_script=google-search-test.py```

That sets the ```my_test_script``` environment variable to the name of an executable script, which subsequently gets copied to ```/``` in your image (via the ```COPY``` instruction on the next line).

And eventually when we reach the point of launching a container, that Python script will be executed by way of the ```CMD``` instruction you see at the last line of the Dockerfile.

- Now, create the file ```google-search-test.py``` in the same dir as your Dockerfile, so that the ```COPY``` command has something to act on.

For that script's content, you can start with a simple hello world example:

    :::python
    #!/usr/bin/env python

    print "Hello world!"

Or, you could go for the gusto and use a more complete GhostDriver script, such as the one from the Github repo related to this post:

<a target="_blank" href="https://github.com/billagee/ghostdriver-py27/blob/master/google-search-test.py">https://github.com/billagee/ghostdriver-py27/blob/master/google-search-test.py</a>

- Once the ```google-search-test.py``` file has been created, you need to make it executable so that it will also be executable in the container:

        :::bash
        chmod 755 google-search-test.py

- Now, try building your image:

        :::bash
        docker build --rm --force-rm -t myrepo/ghostdriver-py27 .

Make sure not to omit the build command's trailing ```.```

The build command output should show the ```apt-get update``` and ```apt-get install``` output, and eventually show your Python script being copied into the image.

## 2. Running a Docker container

Now try executing your Python script in a container, with ```docker run```.

    :::bash
    docker run -it --rm myrepo/ghostdriver-py27

When the container exits, you should see the output of your Python script.

e.g., if your Python script is the hi world example, the run output should resemble:

    :::bash
    $ docker run -it --rm myrepo/ghostdriver-py27
    Hello world!

And here is the output when running the GhostDriver example script from <a target="_blank" href="https://github.com/billagee/ghostdriver-py27/blob/master/google-search-test.py">https://github.com/billagee/ghostdriver-py27/blob/master/google-search-test.py</a>:

    :::bash
    $ docker run -it --rm myrepo/ghostdriver-py27
    Navigating to 'http://www.google.com'...
    Checking search box presence...
    Performing search request...
    current_url is now 'http://www.google.com/search?hl=en&source=hp&biw=&bih=&q=selenium&gbv=2&oq=selenium'
    .
    ----------------------------------------------------------------------
    Ran 1 test in 2.530s
    
    OK

Note that if you make changes to the Python script, re-running the ```docker build``` command will add your new changes to the image.

Also take note of the ```--rm``` option, which causes ```docker run``` to destroy the container on exit. This is nice when rapidly making changes and re-running containers - when working in that fashion, it's better to have less container cruft to clean up later.

## 3. Getting an interactive shell in a Docker container

If you're new to Docker, you might be wondering how to launch a shell in a container and use it interactively.

Here's one way to do it - you can pass the name of an executable to run to ```docker run```, which will override the Python script payload specified in the Dockerfile's ```CMD``` line.

Passing ```bash``` as the executable and using the ```-it``` options to ```docker run``` will give you a bash shell with which you can do anything you like - for example, installing more packages, modifying and re-running your test script, or experimenting with other changes you're considering adding to your Dockerfile.

The full command to get an interactive shell in a container looks like:

    :::bash
    docker run -it myrepo/ghostdriver-py27 bash

You should then see a shell prompt, which you can use to run arbitrary commands (as root) in your Ubuntu container.

For example, you might check the container's phantomjs version, or check the kernel and OS versions:

(Note I'm testing on a Mac running Docker Toolbox, so the ```uname``` output may differ from yours.)

    :::shell
    root@9ed850542508:/# phantomjs --version
    1.9.0

    root@9ed850542508:/# python --version
    Python 2.7.6

    root@9ed850542508:/# lsb_release -a
    No LSB modules are available.
    Distributor ID: Ubuntu
    Description:    Ubuntu 14.04.3 LTS
    Release:    14.04
    Codename:   trusty

    root@9ed850542508:/# uname -a
    Linux 9ed850542508 4.0.9-boot2docker #1 SMP Thu Sep 10 20:39:20 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

In the container, the Python script that you placed in the image with ```COPY ${my_test_script} /``` can be found at ```/google-search-test.py```:

    :::bash
    root@05f05f9d7537:/# ls -la /google-search-test.py
    -rwxr-xr-x 1 root root 1065 Feb 14 04:08 /google-search-test.py

Another useful thing to do is to install your favorite editor, edit the container's Python script, then run the modified script manually:

    :::bash
    root@05f05f9d7537:/# apt-get install vim -y

    # ...snip package installation output...

    root@05f05f9d7537:/# vim /google-search-test.py

    # Make some edits, then launch your modified script:

    root@05f05f9d7537:/# /google-search-test.py

NOTE: When you exit the containerized shell, if the container was launched with ```docker run --rm```,
the container will be destroyed, along with any changes to files you made while interactively working within it.

But if you don't use ```docker run --rm```, once you exit the container shell, you'll see the container in the output of ```docker ps -a```:

    :::bash
    $ docker run -it myrepo/ghostdriver-py27 bash

    root@8a563421bdb3:/# exit
    exit

    $ docker ps -a
    CONTAINER ID        IMAGE                       COMMAND             CREATED             STATUS                      PORTS               NAMES
    8a563421bdb3        myrepo/ghostdriver-py27     "bash"              7 seconds ago       Exited (0) 2 seconds ago                        mad_curie

To remove the container manually you can pass its CONTAINER ID or NAME to ```docker rm```:

    :::bash
    $ docker rm 8a563421bdb3
    8a563421bdb3

## 4. Creating a Makefile

This step is completely optional, but you may find it convenient.

If you're going to be frequently building your image and running containers on the command line, a Makefile can provide convenient shorthand commands to accomplish those tasks.

For example, building your image could look like:

    :::bash
    $ make build

And to run a container:

    :::bash
    $ make

    # ...or `make run` if you want to be explicit

Launching a containerized shell could look like:

    :::bash
    $ make shell

If you're not familiar with Makefiles, setting one up simply involves creating a file named ```Makefile``` (in this case, you should put it in the same dir with your ```Dockerfile```).

The example Makefile in the gist below provides ```build```, ```run```, ```shell```, and ```clean``` targets - the latter deletes your local image using ```docker rmi```.

If you don't want your Makefile to use the example image name (```myrepo/ghostdriver-py27```) used in this post, just change the value of the ```repo_name``` variable in the Makefile.

- NOTE! If running make gives you a separator error like:

        :::bash
        make
        Makefile:11: *** missing separator.  Stop.

...then check to make sure all indentation in your Makefile is done with tab characters. If all else fails, use wget or curl to download the Makefile gist shown below. For example:

    :::bash
    wget https://gist.githubusercontent.com/billagee/a11874bb83d54ffcfaf8/raw/f4cd1e0bd88d56959286774adba77a81e7d2f20d/Makefile

<script src="https://gist.github.com/billagee/a11874bb83d54ffcfaf8.js"></script>

## 5. Pushing your image to Docker Hub

If you want to take the next step toward sharing your image with other users via Docker Hub, here's how to do that.

- First, create a Docker Hub account at <a target="_blank" href="https://hub.docker.com/">hub.docker.com</a>.

- With that done, you can log in to Docker Hub's web UI and use the ```Create Repository``` button to make a new repo.

Set the repository name to whatever you like (e.g., ```experiment```), and choose whether to make the repo visibility public or private. Clicking the Create button wraps things up.

- To push your existing local image (```myrepo/ghostdriver-py27```) to Docker Hub without rebuilding it under a new name, you can perform these steps on the command line:

      * ```docker login```
      * Tag your existing image with the new repo's name: ```docker tag myrepo/ghostdriver-py27 YOUR_DOCKER_USERNAME/YOUR_REPO_NAME```
      * Push the image to its new repo in Docker Hub: ```docker push YOUR_DOCKER_USERNAME/YOUR_REPO_NAME```

Note you'll need to replace ```YOUR_DOCKER_USERNAME/YOUR_REPO_NAME``` with your Docker username and the Docker Hub repo name you chose - e.g., I used ```billagee/experiment```, which looks like this on the CLI:

    :::python
    docker tag myrepo/ghostdriver-py27 billagee/experiment

    docker push billagee/experiment

Once that step is completed, others will be able to ```docker pull``` your image.

Also on the topic of sharing images, the Github repo linked here shows an example of the finished Dockerfile, Makefile, and GhostDriver script produced by completing the steps in this post:

  * <a target="_blank" href="https://github.com/billagee/ghostdriver-py27">https://github.com/billagee/ghostdriver-py27</a>

And here's a Docker Hub repo linked to that Github repo - you can retrieve the latest image from this repo with ```docker pull billagee/ghostdriver-py27```

  * <a target="_blank" href="https://hub.docker.com/r/billagee/ghostdriver-py27/">https://hub.docker.com/r/billagee/ghostdriver-py27/</a>

An interesting feature to point out: A Docker Hub repo (like the one above) linked to a Github repo can be set up to build and push your image automatically when changes are made to the Github repo. You can also manually trigger builds in the Docker Hub web UI, or with an API call.

As an example, here are the results of a manually-triggered build of my image:

<a target="_blank" href="https://hub.docker.com/r/billagee/ghostdriver-py27/builds/bycpbhriwttas2uuxkmbcu4/">https://hub.docker.com/r/billagee/ghostdriver-py27/builds/bycpbhriwttas2uuxkmbcu4/</a>

For more info on the topic of automated builds, see <a target="_blank" href="https://docs.docker.com/docker-hub/builds/">https://docs.docker.com/docker-hub/builds/</a>

Signing off until next time - and viva la containerism!

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Word of the day: containerism<br><br>A social and economic order and ideology encouraging the deployment of containers in ever-increasing amounts.</p>&mdash; Dave Cheney (@davecheney) <a target="_blank" href="https://twitter.com/davecheney/status/692111975162236932">January 26, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

