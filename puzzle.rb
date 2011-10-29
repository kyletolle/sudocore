require 'modularity'

# The data structure for the Sudoku Puzzle.
# Separate from the algorithm used to solve the puzzles.
class Puzzle

  # The values of rows/columns that are part of the same nonet.
  NONET_RANGES = [0..2, 3..5 ,6..8]

  # The decimal values for a puzzle.
  DECIMAL_REGEX = /^[0-9]$/
  DECIMAL_VALUES = (1..9).to_a

  #TODO: Yet to be implemented.
  # The hex values for a puzzle.
  HEX_REGEX = /^[a-zA-z0-9]$/

  # The values of blank cells in the puzzle.
  BLANKS_REGEX = /^[_\.]$/

  ## Names of classes from: http://en.wikipedia.org/wiki/Sudoku#Terminology
  ##
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
  def cell(row_num, col_num)
    return @puzzle[row_num][col_num]
  end

  does "puzzle/houses"

  # Solves sudoku puzzle.
  def solve
    # If the puzzle has already been solved, don't solve it again, just return.
    return self if solved?

    # If the puzzle is not valid, we'll error out.
    @algorithm.solve(self) if valid?

    self
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
    unless @puzzle.size == 9
      raise RuntimeError, "Sudoku puzzle must have 9 rows."
    end

    each_row do |row|
      unless row.size == 9
        raise RuntimeError, "Each row in the Sudoku puzzle must have 9 cells."
      end
    end

    #TODO: Make sure all the characters in the puzzle are valid.
    #TODO: Find out if there are conflicts in row, column or nonet.

    # If we get this far without error, the puzzle is valid.
    return true
  end


  # Has the puzzle been solved? Meaning, do each of the rows, columns and nonets have values 1-9.
  def solved?
    # Return whether the total passed in is equal to the total for a valid house.
    def is_valid_house_total?(total)
      return total == 45
    end

    # Return the total of adding up all the cells in this house.
    def house_total(house)
      return house.inject(0) {|sum, cell| sum + cell.to_i }
    end

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
