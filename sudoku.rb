class Sudoku
  
  DEC_REGEX = /^[0-9]$/
  HEX_REGEX = /^[a-zA-z0-9]$/
  BLANKS_REGEX = /^[_]$/

  ## Names of classes from: http://en.wikipedia.org/wiki/Sudoku#Terminology
  ##
  require "./cell"

  class Row
  end


  class Column
  end


  class Nonet
  end
  

  class House
  end


  require "./sudoku#initialize"

  # Solves sudoku puzzle
  def solve
    #TODO: Determine which algorithm to use to solve the puzzle
    # - Brute Force
    # - Graph Coloring
    # - Some hybrid between the two?
    
    #TODO: Do a not-dumb brute force first.
    #TODO: Then figure out how to abstract the algorithm away, so I can swap in a graph
    # coloring algorithm later!

    if valid?
      try_solve(0)
    else
      raise RuntimeError, "Sudoku puzzle contents were not valid."
    end

    self
  end
  

  require "./sudoku#to_s"

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

  
  def index_to_indices(index)

    row    = index / 9;
    column = index % 9;

    return row, column

  end


  def potential_values(index)
    
    # Check rows, columns and nonets for values we can't be
    # and eliminate them from the values that we can be.
    # So we are left with only a list of potential values
    row_num, col_num = index_to_indices(index)

    row = @puzzle[row]

    col = @puzzle.map {|row| row[col]}

    #TODO: Find the algorithm for calculating nonets!
    #nonet = 
    
  end


  def try_solve(index)

    ## Algorithm
    #
    # convert index to array indices
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
    
    ## Implementation
    
    row, column = index_to_indices(index)
    
    cell = @puzzle[row][column]

    if cell.blank?
      p_vals = potential_values(index)
      #get potential values
    else
      #try_solve(index.next)
      #return solved?
    end

  end


  def valid?

    unless @puzzle.size == 9
      raise RuntimeError, "Sudoku puzzle must have 9 rows."
    end

    return true #TODO: Find out if there are conflicts in row, column or nonet.

  end

  private :add_row, :add_cell, :try_solve, :valid?, :index_to_indices
end
