require 'optparse'

class Sudoku

  class Puzzle < Array

  end
  
DEC_REGEX = /^[0-9]$/
  HEX_REGEX = /^[a-zA-z0-9]$/
  BLANKS_REGEX = /^[_]$/

  #TODO: How can I make options optional and also a hash?
  # Parses sudoku puzzle file and builds data structure for solving.
  # @parm string file path to file containing sudoku puzzle
  #TODO: @parm for options
  def initialize(filename, options)
    
    ## Parse the options ##
    
    # Whether we want to use decimal or hex digits.
    case options[:base]
    when :dec
      @digit_regex = DEC_REGEX

    when :hex
      @digit_regex = HEX_REGEX
    
    else
      raise ArgumentError, ":base option can be either :dec (for decimal) or :hex (for hexadecimal)"
    end

    # Characters to represent valid blank characters in the puzzle
    @blank_regex = BLANKS_REGEX

    ## Read and parse in the puzzle now

    #TODO: I think I'll want to use a puzzle class to abstract things away.
    @puzzle = Puzzle.new

    # Read in the file with the puzzle
    File.open(filename) do |file|
      line_count = 0
      file.each do |line|
        chars = []
        line.chomp.each_char do |char| 
          # Make sure we have either valid digits or blanks
          unless char =~ @digit_regex or char =~ @blank_regex
            raise RuntimeError, "Each character of the Sudoku puzzle must be a valid character or blank entry." 
          end

          chars << char
        end

        # Rows must have 9 characters
        unless chars.count == 9
          raise RuntimeError, "Each row in a Sudoku puzzle must have 9 columns."
        end

        @puzzle << chars
        line_count += 1
      end
      
      # Puzzle must have 9 rows
      unless line_count == 9
        raise RuntimeError, "Sudoku puzzle must have 9 rows."
      end
    end

    # Catch argument errors
    rescue ArgumentError => e
      puts "Error: #{e.message}"
      exit
    
    # Catch file format errors
    rescue RuntimeError => e
      puts "Error: #{e.message}"
      exit

    ## Catch file errors ##

    rescue Errno::ENOENT
      puts "Error: Couldn't find the sudoku file."
    
    rescue Errno::EACCES
      puts "Error: Access denied when accessing the sudoku file."

    rescue Errno::EISDIR
      puts "Error: Given sudoku file was actually a directory, not a file."
    exit

    @puzzle.each do |row| p row end
  end
  
  # Solves sudoku puzzle
  def solve
    #TODO: Determine which algorithm to use to solve the puzzle
    # - Brute Force
    # - Graph Coloring
    # - Some hybrid between the two?
    puts 'TODO: Implement Sudoku#solve'
    self
  end
  
  # Returns string representation of sudoku puzzle for printing
  # @return string
  def to_s
    return 'TODO: Implement Sudoku#to_s';
  end
end

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
sudoku = Sudoku.new(filename, base: :dec)
puts sudoku.solve.to_s
