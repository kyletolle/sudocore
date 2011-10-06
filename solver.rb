require 'optparse'

require './sudoku'

# Hold the parsed options
options = {}

# Define the options and their uses
optparse = OptionParser.new do |opts|
  # Set a banner message at the top of the help screen
  opts.banner = "Usage: ruby #{File.basename(__FILE__)} [options] file"

  #TODO: Enforce that a filename is required.

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

#TODO: Use flag from command line to pass along whether this is hex or decimal
sudoku = Sudoku.new(filename)
puts sudoku.solve.to_s
