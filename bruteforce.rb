require './algorithm'

# An implementation of Algorithm that solves Sudoku via brute force.
class BruteForce < Algorithm
  # Solves the given sudoku puzzle.
  def solve(puzzle)
    @puzzle = puzzle

    puts "Solving..."
    puts "This may take a while"
    puts
    
    try_solve(0)

    self
  end
  

  # Brute force solution to solve the puzzle starting at index.
  def try_solve(index)
    #TODO: Should this be made into some debug functionality?
    #print_on = [0]
    #if print_on.include?(index)
    #  puts @puzzle
    #end
    #puts "Waiting to go ahead. Hit enter."
    #STDIN.gets

    # If we've completed the entire puzzle, we want to make sure it's been validly solved.
    if index == (9*9)
      return @puzzle.solved?
    end

    # Get the row and column numbers for this cell's base index.
    row_num = index_to_row(index)
    col_num = index_to_col(index)
    
    cell = @puzzle.cell(row_num, col_num)

    # If the cell is blank, we need to process it.
    if cell.blank?
      p_vals = potential_values(index)

      return false if p_vals.empty?

      p_vals.each do |p_val|
        # Set this cell to the potential value.
        cell.char = p_val

        # And try to solve the rest of the puzzle.
        result = try_solve(index.next)
        if result
          return true
        else
          next
        end
      end

      # If we didn't solve the puzzle with these values, some value before us is wrong.
      # Resets the value here to be blank so it can be changed later.
      cell.char = "."
      return false

    # If the cell isn't blank, we process the next cell.
    else
      try_solve(index.next)
    end
  end
  
  ## For index_to_* methods, the following must be true for valid results:
  ## 0 <= index < (base*base)
  ## ie. The index must be greater than or equal zero but less than the number of cells
  ##     in the puzzle (the index is zero based).
  ##
  # Maps cell index to row number.
  def index_to_row(index)
    row = index / 9
  end


  # Maps cell index to column number.
  def index_to_col(index)
    column = index % 9
  end


  # Maps cell index to nonet number.
  def index_to_nonet(index)
    # Get the row and column for the cell.
    row = index_to_row(index)
    col = index_to_col(index)

    # Determine which nonet range includes this cell's row.
    nonet_row = 0
    Puzzle::NONET_RANGES.each_with_index do |row_range, row_index|
      if row_range.include?(row)
        nonet_row = row_index
        break
      end
    end

    # Determine which nonet range includes this cell's column.
    nonet_col = 0
    Puzzle::NONET_RANGES.each_with_index do |col_range, col_index|
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
    ## We are left with only a list of potential values.
    ##
    row_of_index = @puzzle.row(index_to_row(index))
    row_vals = non_blank_house_values_as_integers(row_of_index)

    col_of_index = @puzzle.column(index_to_col(index))
    col_vals = non_blank_house_values_as_integers(col_of_index)

    nonet_of_index = @puzzle.nonet(index_to_nonet(index))
    nonet_vals = non_blank_house_values_as_integers(nonet_of_index)

    # Merge the row, column and nonet values into a unique list.
    house_vals = (row_vals | col_vals | nonet_vals).uniq

    # Potential values for this cell are all the values that don't conflict
    # with the actual values of other cells in this cell's house.
    potential_vals = Puzzle::DECIMAL_VALUES - house_vals

    potential_vals.sort!
  end


  private :try_solve, :potential_values
end
