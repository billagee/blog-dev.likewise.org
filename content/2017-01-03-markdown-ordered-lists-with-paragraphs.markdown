Title: Markdown ordered lists with paragraphs
Date: 2017-01-03 17:26
Tags: Markdown, Pelican
Slug: markdown-ordered-lists-with-paragraphs

Keeping a Markdown ordered list in proper working order has always been tricky for me. I always seem to end up up with indentation characters that reset the next item back to the number 1.

Here's how to make a list containing paragraphs without the list item numbers resetting.

The key appears to be to indent each line of content by an equal number of spaces - and indent both blank lines and those with text.

## Example markdown source:

        1. This is an example ordered list
            
            Look, a paragraph!
            
            And another!
            
        1. This is the second item.

        1. Here's another list with a code block.
            
            Here's the first paragraph.
            
            And here's some code:
            
            :::bash
            echo "Hello world!"
            
            And another block of code:
            
            :::bash
            echo "Bye world!"
            
            All done!
            
        1. This is the fourth list item.

## Here's what the above looks like after rendering with pelican:

1. This is an example ordered list
    
    Look, a paragraph!
    
    And another!
    
1. This is the second item.

1. Here's another list with a code block.
    
    Here's the first paragraph.
    
    And here's some code:
    
        :::bash
        echo "Hello world!"
    
    And another block of code:
    
        :::bash
        echo "Bye world!"
    
    All done!
    
1. This is the fourth list item.

