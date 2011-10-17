class Puzzle
  
  # Represent the values of rows/columns that are part of the same nonet.

  NONET_RANGES = [0..2, 3..5 ,6..8]

  DECIMAL_REGEX = /^[0-9]$/
  DECIMAL_VALUES = (1..9).to_a

  HEX_REGEX = /^[a-zA-z0-9]$/

  BLANKS_REGEX = /^[_\.]$/

  ## Names of classes from: http://en.wikipedia.org/wiki/Sudoku#Terminology
  ##
  require "./cell"  
  require "./house"


  ##--------------------------------------------
  # Returns each cell in the puzzle
  def each
    # Return each cell of each row in the array
    @puzzle.each do |row|
      row.each do |cell|
        yield cell
      end
    end
  end


  # Returns houses that represent each row in the puzzle
  def each_row
    @puzzle.each do |row|
      yield row
    end
  end


  # Returns houses that represent each column in the puzzle
  def each_column

    # For all columns
    (0..8).each do |col_num|
      
      # Start with an empty column
      col_cells = []

      # Add value of the column for each row to the column array
      (0..8).each do |row_num|
        col_cells << @puzzle[row_num][col_num]
      end

      # Yield the column
      yield col_cells
    end

  end


  # Returns houses that represent each nonet in the puzzle
  def each_nonet
    
    # Loop over the ranges as row values and again as column values to cover all the nonets
    NONET_RANGES.each do |row_range|
      NONET_RANGES.each do |col_range|

        # Start with an empty nonet
        nonet_cells = []

        # Loop through each value in the row/column range
        row_range.each do |row_num|
          col_range.each do |col_num|
            # Add the value for the cell in the nonet to the nonet array
            nonet_cells << @puzzle[row_num][col_num]
          end
        end

        # Yield the nonet
        yield nonet_cells

      end
    end
    
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
  ##--------------------------------------------


  require "./puzzle#initialize"

  #TODO: What happens if solve is called twice?
  # Solves sudoku puzzle
  def solve
    #TODO: Determine which algorithm to use to solve the puzzle
    # - Brute Force
    # - Graph Coloring
    # - Some hybrid between the two?
    
    puts "Solving..."
    puts "This may take a while"
    puts
    
    #TODO: Do a not-dumb brute force first.
    #TODO: Then figure out how to abstract the algorithm away, so I can swap in a graph
    # coloring algorithm later!
    #TODO: Need to catch if a row doesn't have 9 cells.
    if valid?
      try_solve(0)
    else
      raise RuntimeError, "Sudoku puzzle contents were not valid."
    end

    self
  end
  

  require "./puzzle#to_s"

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

  
  # Maps cell index to row number
  def index_to_row(index)
    #TODO: Check for valid values.
    row = index / 9
  end


  # Maps cell index to column number
  def index_to_col(index)
    #TODO: Check for valid values.
    column = index % 9
  end


  # Maps cell index to nonet number
  def index_to_nonet(index)
    #TODO: Check for valid values.

    # Get the row and column for the cell
    row = index_to_row(index)
    col = index_to_col(index)

    # Determine which nonet range includes this cell's row
    nonet_row = 0
    NONET_RANGES.each_with_index do |row_range, row_index|
      if row_range.include?(row)
        nonet_row = row_index
        break
      end
    end

    # Determine which nonet range includes this cell's column
    nonet_col = 0
    NONET_RANGES.each_with_index do |col_range, col_index|
      if col_range.include?(col)
        nonet_col = col_index
        break
      end
    end

    # Map the nonet row and column to a nonet index.
    nonet_num = (nonet_row * 3) + nonet_col
  end
  

  # Return the house's non-blank values as integers.
  def non_blank_house_values_as_integers(house)
    house_vals = house.select do |cell|
      not cell.blank?
    end

    house_vals.map! {|cell| cell.to_i }
  end
  
  
  # Return a sorted, unique list of the possible values the cell at
  # puzzle's index position could be.
  def potential_values(index)

    ## Check the cell's houses for values we can't be
    ## and eliminate them from the values that we can be.
    ## So we are left with only a list of potential values
    ##
    row_of_index = row(index_to_row(index))
    row_vals = non_blank_house_values_as_integers(row_of_index)

    col_of_index = column(index_to_col(index))
    col_vals = non_blank_house_values_as_integers(col_of_index)

    nonet_of_index = nonet(index_to_nonet(index))
    nonet_vals = non_blank_house_values_as_integers(nonet_of_index)

    # Merge the row, column and nonet values into a unique list.
    house_vals = (row_vals | col_vals | nonet_vals).uniq

    # Potential values for this cell are all the values that don't conflict
    # with the actual values of other cells in this cell's house.
    potential_vals = DECIMAL_VALUES - house_vals

    potential_vals.sort!

  end


  def try_solve(index)
    #TODO:REMOVE ME!
    #print_on = [0]
    #if print_on.include?(index)
    #  puts self.to_s
    #end
    #puts "Waiting to go ahead. Hit enter."
    #STDIN.gets

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
    
    # If we've completed the entire puzzle, we want to make sure it's been validly solved.
    if index == (9*9)
      return solved?
    end

    row_num = index_to_row(index)
    col_num = index_to_col(index)
    
    cell = @puzzle[row_num][col_num]

    if cell.blank?
      p_vals = potential_values(index)

      return false if p_vals.empty?

      p_vals.each do |p_val|
        # Set this cell to the potential value
        cell.char = p_val

        # And try to solve the rest of the puzzle
        result = try_solve(index.next)
        if result
          return true
        else
          next
        end
      end

      # Resets the value here to be blank so it can be changed later.
      cell.char = "."
      return false

    else
      try_solve(index.next)
    end

  end


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


  private :add_row, :add_cell, :try_solve, :valid?, :solved?
end
