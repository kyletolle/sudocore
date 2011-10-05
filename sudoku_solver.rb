require 'optparse'

class Sudoku
  
  DEC_REGEX = /^[0-9]$/
  HEX_REGEX = /^[a-zA-z0-9]$/
  BLANKS_REGEX = /^[_]$/

  ## Names of classes from: http://en.wikipedia.org/wiki/Sudoku#Terminology
  ##
  class Cell

    def initialize(char)
      #
      #TODO: Check to see if char matches the digit or blank regexes.
      #If so, store it. If not, raise error.
      #
      #TODO: How do we see what base the Cell should be in based on Sudoku's base?
      if char =~ DEC_REGEX or char =~ BLANKS_REGEX
        # Make all blank characters a period for readability in output.
        if char =~ BLANKS_REGEX
          char.replace(".")
        end
        @char = char
      else
        raise ArgumentError, "Each character of the Sudoku puzzle's cells must be a valid character or blank entry."
      end

    end


    def blank?

      #TODO: How do we see what base the Cell should be in based on Sudoku's base?
      return @char =~ BLANKS_REGEX # whether char matches blanks regex

    end


    def to_s

      @char.to_s

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
    ##
    #TODO: I think I'll want to use a puzzle class to abstract things away.
    @puzzle = [] #Puzzle.new
    @current_row = nil

    # Read in the file with the puzzle
    File.open(filename) do |file|
      file.each do |line|
        line.chomp.each_char do |char| 
          # Add this cell to the puzzle
          add_cell(Cell.new(char))
        end

        add_row
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
    ##
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

    unless @puzzle.size == 9
      raise RuntimeError, "Sudoku puzzle must have 9 rows."
    end

    if valid?
      try_solve(0)
    else
      raise RuntimeError, "Sudoku puzzle contents were not valid."
    end

    self
  end
  

  # Returns string representation of sudoku puzzle for printing
  # @return string
  def to_s
    
    # Make a pretty string of the puzzle
    visual_puzzle = 
    @puzzle.each_with_index.inject("") do |puzzle_string, (row, row_num)|
      if (row_num+1) % 3 == 0 and row_num < 8
        row_sep = " - - - + - - - + - - -\n"
      else
        row_sep = ""
      end

      row.each_with_index.inject(puzzle_string) do |row_string, (cell, cell_num)|
          if (cell_num+1) % 3 == 0 and cell_num < 8
            sep = " |"
          else
            sep = ""
          end

          row_string + " " + cell.to_s + sep
        end + "\n" + row_sep
    end

    "\n" + visual_puzzle + "\n"

  end


  def add_row

    unless @current_row.nil?
      @puzzle << @current_row
      @current_row = nil
    end

  end


  def add_cell(cell)

    @current_row ||= []
    
    if @current_row.size < 9
      unless cell.class == Cell.class
        @current_row << cell
      else
        raise RuntimeError, "Must add a cell to the Sudoku puzzle"
      end
    else
      raise RuntimeError, "Sudoku puzzle can't have more than 9 Cells in a row. You added #{@current_row.size} elements."
    end

  end


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

  def valid?
    return true #TODO: Find out if there are conflicts in row, column or nonet.
  end

  private :add_row, :add_cell, :try_solve, :valid?
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
