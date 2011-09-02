require 'optparse'

class Sudoku
  
  # Parses sudoku puzzle file and builds data structure for solving.
  # @parm string file path to file containing sudoku puzzle
  def initialize(file)
    @puzzle = []
  end
  
  #
  # Solves sudoku puzzle
  def solve
    
  end
  
  # Returns string representation of sudoku puzzle for printing
  # @return string
  def to_s
    return 'TODO: Implement Sudoku#to_s';
  end
end

# TODO: Parse command line options
# Hold the parsed options
options = {}

# Define the options and their uses
optparse = OptionParser.new do |opts|
  # Set a banner message at the top of the help screen
  opts.banner = "Usage: ruby sudoku-solver.rb [options] file"

  #TODO: Need to handle invalid options and the exceptions thrown by
  # OptionParser

  #TODO: Perhaps use a flag here for whether it's numeric or hex

  # Displays the help screen
  opts.on('-h', '--help', 'Display this help screen') do
    puts opts
    exit
  end
end

# Parse the command line, removing any options, leaving the filename we want
optparse.parse!

filename = ARGV[0]

sudoku = Sudoku.new(filename)
sudoku.solve
puts sudoku
