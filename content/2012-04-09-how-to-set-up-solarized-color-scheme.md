Title: How to set up the Solarized color scheme for vim and iTerm2
Date: 2012-04-09T22:18:00-07:00
Tags: vim, iTerm2, Solarized, OS X
Slug: how-to-set-up-solarized-color-scheme
Alias: /2012/04/how-to-set-up-solarized-color-scheme.html

![Solarized Vim Screenshot]({attach}images/solarized.png)

When you stare at a display full of text for hours at a time, a nice looking color scheme is worth the time it takes to set up.

Enter <a target="_blank" href="http://ethanschoonover.com/solarized">Solarized</a>, a great option for improving your overall text-editing life.

My officemate <a target="_blank" href="http://www.kevinbeddingfield.com/">Kevin</a> has been evangelizing Solarized for a while, so today I took the plunge and set it up, and man do I wish I had done this a while ago.  Much of the content described below is straight from his setup - I definitely owe him.

The set of software I'm currently using with Solarized is:

- <a target="_blank" href="https://iterm2.com/">iTerm2</a> (since in my experience it handles Solarized better than Terminal.app)
- The command-line vim that ships with OSX
- <a target="_blank" href="https://github.com/tpope/vim-pathogen">pathogen.vim</a> (for easy installation of vim plugins)
- The Solarized config files for iTerm2 and vim
- <a target="_blank" href="https://github.com/scrooloose/nerdtree">NERDTree</a> (a tree explorer for vim)

For future reference, here's how I set everything up:

1. Download the stable version of iTerm2 from <a target="_blank" href="https://iterm2.com/">iterm2.com</a>

1. Download and unzip <a target="_blank" href="http://ethanschoonover.com/solarized/files/solarized.zip">the latest version of the Solarized .zip file</a> (it contains the iTerm2 preset files you'll need)

1. In iTerm2, open *iTerm2 > Preferences > Profiles > Colors*, and click *Load Presets...* to load the Solarized color schemes (light and dark) that are found in the .zip in ```solarized/iterm2-colors-solarized/```

    For more info see <a target="_blank" href="https://github.com/altercation/solarized/blob/master/iterm2-colors-solarized/README.md">the iterm2-colors-solarized README</a>.

1. Follow <a target="_blank" href="https://github.com/tpope/vim-pathogen#readme">these instructions from the pathogen github README</a> to install pathogen. In the next step, we'll be using pathogen to install more bits.

1. Install solarized.vim using pathogen:
    
    (For more info see <a target="_blank" href="http://ethanschoonover.com/solarized/vim-colors-solarized">http://ethanschoonover.com/solarized/vim-colors-solarized</a>)

        :::bash
        cd ~/.vim/bundle
        git clone git://github.com/altercation/vim-colors-solarized.git

    In the parent directory of vim-colors-solarized:

        :::bash
        mv vim-colors-solarized ~/.vim/bundle/

1. Install NERDTree:
    
    (See also <a target="_blank" href="http://programming34m0.blogspot.com/2011/04/nerd-tree-file-explorer-with-mac-vim.html">http://programming34m0.blogspot.com/2011/04/nerd-tree-file-explorer-with-mac-vim.html</a>)
    
        :::bash
        cd ~/.vim/bundle
        git clone git://github.com/scrooloose/nerdtree.git

1. Set up your .vimrc appropriately - here's mine:
        
        :::vim
        set ruler
        set cursorline
        call pathogen#infect()
        syntax on

        filetype plugin indent on

        syntax enable

        " Solarized stuff
        let g:solarized_termtrans = 1
        set background=dark
        colorscheme solarized

1. OPTIONAL: A nice choice for a terminal font is Inconsolata-dz - you can download it here, and configure iTerm2 to use it:
    
    <a target="_blank" href="http://nodnod.net/2009/feb/12/adding-straight-single-and-double-quotes-inconsola/">http://nodnod.net/2009/feb/12/adding-straight-single-and-double-quotes-inconsola/</a>
