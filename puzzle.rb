require 'modularity'

class Base

end

class Decimal < Base
  N = 9;
  
  # The decimal values for a puzzle.
  VALUES = (1..9).to_a
  RANGE = (0..8)
  
  HOUSE_TOTAL = 45

  # The values of rows/columns that are part of the same nonet.
  NONET_SIZE = 3
  NONET_RANGES = [0..2, 3..5 ,6..8]

  INPUT = {"1"=>"1", "2"=>"2", "3"=>"3",
           "4"=>"4", "5"=>"5", "6"=>"6",
           "7"=>"7", "8"=>"8", "9"=>"9"}

  OUTPUT = {1=>"1", 2=>"2", 3=>"3",
            4=>"4", 5=>"5", 6=>"6",
            7=>"7", 8=>"8", 9=>"9"}
end

class Hexadecimal < Base
  N = 16;

  # The hex values for a puzzle.
  VALUES = (1..16).to_a
  RANGE = (0..15)

  HOUSE_TOTAL = 136

  NONET_SIZE = 4
  NONET_RANGES = [0..3, 4..7, 8..11, 12..15]

  INPUT = {"0"=>"1",  "1"=>"2",  "2"=>"3",  "3"=>"4",
           "4"=>"5",  "5"=>"6",  "6"=>"7",  "7"=>"8",
           "8"=>"9",  "9"=>"10", "A"=>"11", "B"=>"12",
           "C"=>"13", "D"=>"14", "E"=>"15", "F"=>"16"}
  

  #Starts with 1 and ands with 16 to keep the values 1-index
  OUTPUT = {1=>"0",  2=>"1",  3=>"2",  4=>"3",
            5=>"4",  6=>"5",  7=>"6",  8=>"7",
            9=>"8",  10=>"9",  11=>"A", 12=>"B",
            13=>"C", 14=>"D", 15=>"E", 16=>"F"}
end

# The data structure for the Sudoku Puzzle.
# Separate from the algorithm used to solve the puzzles.
class Puzzle

  # The values of blank cells in the puzzle.
  BLANKS_REGEX = /^[_\.]$/

  # Names of class from: http://en.wikipedia.org/wiki/Sudoku#Terminology
  require "./cell"

  ## Bring in other methods.
  ##

  require './puzzle/creation_trait.rb'
  require './puzzle/each_methods_trait.rb'
  require "./puzzle/output_trait.rb"
  require "./puzzle/houses_trait.rb"

  does "puzzle/creation"
  does "puzzle/output"
  does "puzzle/each_methods"


  # Returns the cell from the position [row][column] specified.
  # Row and column numbers must be in the range for the base of the puzzle.
  def cell(row_num, col_num)
    return @puzzle[row_num][col_num]
  end


  does "puzzle/houses"


  # Solves a valid sudoku puzzle.
  def solve
    # If the puzzle has already been solved, don't solve it again, just return.
    return self if solved?

    # If the puzzle is not valid, we'll error out.
    @algorithm.solve(self, @base) if valid?

    self
  # Catch puzzle validity errors
  rescue => e
    puts "Error: #{e.message}"
    exit
  end


  # Add the current row to the puzzle.
  def add_row
    unless @current_row.nil?
      # Add the row to the puzzle.
      @puzzle << @current_row
      # And clear the row.
      @current_row = nil
    end
  end


  # Add a cell to the current row of the puzzle.
  def add_cell(cell)
    # If there is no row yet, create a blank array for it.
    @current_row ||= []
    # Add the cell to the end of the row.
    @current_row << cell
  end


  # Check to make sure the puzzle, as read in from the file, is valid and can be solved.
  def valid?
    # Valid puzzle has N rows.
    unless @puzzle.size == @base::N
      raise RuntimeError, "Sudoku puzzle must have #{@base::N} rows."
    end

    # Valid puzzle has N columns of N cells.
    each_row do |row|
      unless row.size == @base::N
        raise RuntimeError, "Each row in the Sudoku puzzle must have #{@base::N} cells."
      end
    end

    # Valid puzzle has valid cells.
    each do |cell|
      cell.valid?
    end

    #TODO: Find out if there are conflicts in row, column or nonet.

    # If we get this far without error, the puzzle is valid.
    return true
  end


  # Return whether the total passed in is equal to the total for a valid house.
  def is_valid_house_total?(total)
    return total == @base::HOUSE_TOTAL
  end


  # Return the total of adding up all the cells in this house.
  def house_total(house)
    return house.inject(0) {|sum, cell| sum + cell.to_i }
  end


  # Has the puzzle been solved? Meaning, do each of the rows, columns and nonets have values 1-9.
  def solved?
    ## Check whether all the houses in the puzzle have valid totals.
    ##

    each_row do |row|
      return false unless is_valid_house_total?(house_total(row))
    end

    each_column do |column|
      return false unless is_valid_house_total?(house_total(column))
    end

    each_nonet do |nonet|
      return false unless is_valid_house_total?(house_total(nonet))
    end
  end


  private :add_row, :add_cell, :valid?
end
