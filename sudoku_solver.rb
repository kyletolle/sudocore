require 'optparse'

class Sudoku

  DEC_REGEX = /^[0-9]$/
  HEX_REGEX = /^[a-zA-z0-9]$/
  BLANKS_REGEX = /^[_]$/
  
  # Names of classes from: http://en.wikipedia.org/wiki/Sudoku#Terminology
  #
  class Puzzle
    # Is a n*n array of Cells
    #TODO: How do I add cells to the puzzle?

    class Cell
  
      def initialize(char)
        #TODO: Check to see if char matches the digit or blank regexes.
        #If so, store it. If not, raise error.
        #
      end
  
      def blank?
        return # whether char matches blanks regex
      end
  
    end
  
    class Row
    end
  
    class Column
    end
  
    class Nonet
    end
    
    class House
    end
  end

  #TODO: How can I make options optional and also a hash?
  # Parses sudoku puzzle file and builds data structure for solving.
  # @parm string file path to file containing sudoku puzzle
  #TODO: @parm for options
  def initialize(filename)
    
    #TODO: Add whether we want to use decimal or hex digits.
      @digit_regex = DEC_REGEX

    # Characters to represent valid blank characters in the puzzle
    @blank_regex = BLANKS_REGEX

    ## Read and parse in the puzzle now

    #TODO: I think I'll want to use a puzzle class to abstract things away.
    @puzzle = [] #Puzzle.new

    # Read in the file with the puzzle
    File.open(filename) do |file|
      line_count = 0
      file.each do |line|
        chars = []
        line.chomp.each_char do |char| 
          # Make sure we have either valid digits or blanks
          unless char =~ @digit_regex or char =~ @blank_regex
            #TODO: Move this error into a class inside Puzzle.
            raise RuntimeError, "Each character of the Sudoku puzzle must be a valid character or blank entry." 
          end

          chars << char
        end

        # Rows must have 9 characters
        #TODO: Move this error into a class inside Puzzle.
        unless chars.count == 9
          raise RuntimeError, "Each row in a Sudoku puzzle must have 9 columns."
        end

        @puzzle << chars
        line_count += 1
      end
      
      # Puzzle must have 9 rows
      #TODO: Move this error into a class inside Puzzle.
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
    
    #TODO: Do a not-dumb brute force first.
    #TODO: Then figure out how to abstract the algorithm away, so I can swap in a graph
    # coloring algorithm later!

    puts 'TODO: Implement Sudoku#solve'
    self
  end
  
  # Returns string representation of sudoku puzzle for printing
  # @return string
  def to_s
    # Make a string of all the puzzle values
    @puzzle.inject("") do |str1, row|
      # Put all the values onto one line
      row.inject(str1) {|str2, val| str2 + val } + "\n"
    end
  end

  private
  def try_solve(index)
    # if already filled in
    #   try_solve(next index)
    #   return solved?
    # else
    #   get potential values
    #   if no potential values
    #     return false
    #   
    #   for each potential value
    #     fill in spot with value
    #     if last box
    #       return puzzle is valid?
    #     try_solve(next index)
    #     if solved?
    #       break
    #     else
    #       next

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
sudoku = Sudoku.new(filename)
puts sudoku.solve.to_s
