## Sudocore - A Sudoku solver written in Ruby
##

# Parse the command line options and get the filename that holds the puzzle.
require './command_line_parser'
cmd_parser = CommandLineParser.new
file = cmd_parser.parse!.file

# Create the puzzle with the file
require './puzzle'
puzzle = Puzzle.new(file)

puts "Starting puzzle at #{Time.now}\n\n"

# Write out the puzzle before it is solved.
puts "Unsolved puzzle:"
puts "#{puzzle.to_s}"

puzzle.solve

# Write out the puzzle after it is solved.
puts "Solved puzzle:"
puts "#{puzzle.to_s}"

puts "Solved puzzle at #{Time.now}"
