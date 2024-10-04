Title: Installing Sikuli 1.0.1 on Ubuntu 12.04
Date: 2014-03-26 13:53
Tags: Sikuli, Ubuntu
Slug: installing-sikuli-1-dot-0-1-on-ubuntu-12-dot-04

While working on a <a href="http://stackoverflow.com/questions/22651721/sikuli-automation-in-ubuntu/22672339#22672339">stackoverflow answer</a> about Sikuli today, I noted that installing Sikuli on Ubuntu 12.04 isn't a one-step process - there are a few dependencies that need manual intervention before you even install it.

Here's the rundown of the steps that worked for me to get a simple Sikuli script working:

### 1. Install the Oracle JRE

I used version 1.7.0_51:

    :::bash
    $ java -version
    java version "1.7.0_51"
    Java(TM) SE Runtime Environment (build 1.7.0_51-b13)
    Java HotSpot(TM) 64-Bit Server VM (build 24.51-b03, mixed mode)

Make sure java is in your PATH, or else the Sikuli IDE will have issues.

### 2. Install OpenCV 2.4.0

    :::bash
    sudo add-apt-repository ppa:gijzelaar/opencv2.4
    sudo apt-get update
    sudo apt-get libcv-dev

Alternatively, you can probably achieve the same by building/installing OpenCV 2.4.0 from source. I went the package route, though.

### 3. Install Tesseract 3

    :::bash
    sudo apt-get install libtesseract3

### 4. Download and launch sikuli-setup.jar

As recommended in the Sikuli install guide, I saved the installer to ~/SikuliX and ran it there as well.

    :::bash
    mkdir ~/SikuliX
    cd ~/SikuliX && java -jar sikuli-setup.jar

From there, I selected the "Pack 1" option in the GUI and let setup proceed normally.

### 5. Launch the Sikuli IDE, create a Sikuli script, and run it.

To launch the IDE, I'm using the command:

    :::bash
    ~/SikuliX/runIDE

If the IDE dies without an error after you try running your script with the **Run** button in the GUI, running your .sikuli project on the command line may help uncover what's going wrong.

To do so, you can use the "runIDE -r" option; you'll hopefully get much more info about the error.

For example, running the project "foo.sikuli" on the command line is as simple as:

    :::bash
    ~/SikuliX/runIDE -r foo.sikuli
