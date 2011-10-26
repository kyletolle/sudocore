require 'modularity'

# The data structure for the Sudoku Puzzle
# Is separate from the algorithm used to solve the puzzles.
class Puzzle
  
  # The values of rows/columns that are part of the same nonet.
  NONET_RANGES = [0..2, 3..5 ,6..8]

  # The decimal values for a puzzle
  DECIMAL_REGEX = /^[0-9]$/
  DECIMAL_VALUES = (1..9).to_a

  #TODO: Yet to be implemented
  # The hex values for a puzzle.
  HEX_REGEX = /^[a-zA-z0-9]$/

  # The values of blank cells in the puzzle
  BLANKS_REGEX = /^[_\.]$/

  ## Names of classes from: http://en.wikipedia.org/wiki/Sudoku#Terminology
  ##
  require "./cell"  
  require "./house"


  ## Bring in other methods
  ##
  require './puzzle/initialize_trait.rb'
  require './puzzle/each_methods_trait.rb'
  require "./puzzle/to_s_trait.rb"

  does "puzzle/initialize"
  does "puzzle/each_methods"
  does "puzzle/to__s"

  # Returns the cell from the position [row][column] specified.
  def cell(row_num, col_num)
    #TODO: Error check on the numbers to name sure it's in range.
    return @puzzle[row_num][col_num]
  end

  
  # Returns the house of cells from the row specified.
  def row(row_num)
    #TODO: Error check on the number to name sure it's in range.
    return @puzzle[row_num]
  end


  # Returns the house of cells from the nonet specified.
  def column(col_num)
    #TODO: Error check on the number to name sure it's in range.

    # Start with an empty column
    column = []

    # Add the cell from the column index of each row.
    @puzzle.each do |row|
      column << row[col_num]
    end

    return column

  end


  # Returns the house of cells from the nonet specified.
  def nonet(nonet_num)
    #TODO: Error check on the number to name sure it's in range.

    ## Calculate row and column of nonet from the number
    ##
    row_num = nonet_num / 3;
    col_num = nonet_num % 3;

    # The row and column range which represents the nonet
    row_range = NONET_RANGES[row_num]
    col_range = NONET_RANGES[col_num]
    
    # Start with a blank nonet
    nonet_cells = []

    ## Add each cell in the nonet to the array
    ##
    row_range.each do |row|
      col_range.each do |col|
        nonet_cells << @puzzle[row][col]
      end
    end

    return nonet_cells

  end


  # Solves sudoku puzzle
  def solve
    
    # If the puzzle has already been solved, don't solve it again, just return.
    return self if solved?

    #TODO: Need to catch if a row doesn't have 9 cells.
    if valid?
      @algorithm.solve(self)
    else
      raise RuntimeError, "Sudoku puzzle contents were not valid."
    end    
    
    self
  end
  

  # Add the current row to the puzzle
  def add_row

    unless @current_row.nil?
      @puzzle << @current_row
      @current_row = nil
    end

  end


  # Add a cell to the current row of the puzzle
  def add_cell(cell)

    @current_row ||= []
    
    if @current_row.size < 9
      unless cell.class == Cell.class
        @current_row << cell
      else
        raise RuntimeError, "Must add a cell to the Sudoku puzzle."
      end
    else
      raise RuntimeError, "Sudoku puzzle can't have more than 9 Cells in a row."
    end

  end

  
  # Check to make sure the puzzle, as read in from the file, is valid and can be solved.
  def valid?

    unless @puzzle.size == 9
      raise RuntimeError, "Sudoku puzzle must have 9 rows."
    end

    return true #TODO: Find out if there are conflicts in row, column or nonet.

  end


  # Has the puzzle been solved? Meaning, do each of the rows, columns and nonets have values 1-9
  def solved?

    # Return whether the total passed in is equal to the total for a valid house.
    def is_valid_house_total?(total)
      return total == 45
    end

    # Return the total of adding up all the cells in this house
    def house_total(house)
      return house.inject(0) {|sum, cell| sum + cell.to_i }
    end
    
    ## Check whether all the houses in the puzzle have valid totals
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
