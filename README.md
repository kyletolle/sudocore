Sudocore
========

Hi, I'm Kyle!

Ever solved a Sudoku puzzle? Me neither, but I'll do you one better. How about a magical potion that'll solve any Sudoku puzzle you could dream up? One part imagination, one part Ruby, one laziness and BAM! you got yourself a brand new car in the driveway. Yep, that just happened! I'm that good a salesman. Don't worry, the sudoku solver is in the glovebox and the monthly installments for the car are low, so you got a nifty deal!

Usage
--------
Sudocore is a Ruby script that just loves doing Sudoku puzzles. Want to run it to solve one for you, or perhaps check one you did by hand (Oh, the humanity!)? Well you can; truly, truly you can! Put the puzzle in a file: a valid 9x9 sudoku puzzle, of course. Underscores and dots are valid blank characters. Then run Sudocore from the commandline, like so:
ruby sudocore.rb puzzlefile

Then we're off to the races! It'll solve most puzzles quick-like.

Dependencies
--------
[modularity][1]

        [sudo] gem install modularity

ToDo
--------
There are a lot of improvements to be had:

- Better error handling
- More comments and code refactoring
- More brute-forcey brute force algorithm
- Solve 16x16 solve hexadecimal puzzles
- Bring in other algorithms to solve the puzzle with
- A slew of command line switches to pass in to alter behavior of the program
- Performance enhancements

Don't worry, you just sit back and I'll take care of that. Hell, go out for a drive in your sweet new ride! You deserve it.

Design Notes
--------
This [article on duck typing](http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/100511) influenced some of my decisions regarding errors.

I will not try to predict every way in which someone might misuse methods. Methods will document any assumptions/requirements and it will be up to the user to comply. If they do not comply, they'll get an error. This will make development and maintenenace easier. And I'll likely be the only user. Errors will still be caught and should still be pretty easy to figure out.

I'll also use Duck typing. Trying to ween myself off the static-typed mindset. Again, errors will be evident here if a method fails later because the wrong object was used.
[1]: https://github.com/makandra/modularity
