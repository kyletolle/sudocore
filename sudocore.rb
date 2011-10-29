## Sudocore - A Sudoku solver written in Ruby.
##

# Parse the command line options and get the filename that holds the puzzle.
require './command_line_parser'
cmd_parser = CommandLineParser.new
cmd_parser.parse!

file = cmd_parser.file
switches = cmd_parser.switches

# Create the puzzle with the file.
require './puzzle'
puzzle = Puzzle.new(file)

# Set up timer with whether user wants to log time info, and to what detail.
require './timer'
timer = Timer.new(switches[:time])


# Write out the puzzle before it is solved.
puts "Unsolved puzzle:"
puts "#{puzzle.to_s}"

timer.start
puzzle.solve
timer.stop

# Write out the puzzle after it is solved.
puts "Solved puzzle:"
puts "#{puzzle.to_s}"

