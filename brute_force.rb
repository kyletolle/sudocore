require './algorithm'

# An implementation of Algorithm that solves Sudoku via brute force.
class BruteForce < Algorithm
  # Solves the given sudoku puzzle.
  def solve(puzzle, base)
    @puzzle = puzzle
    @base = base

    puts "Solving..."
    puts "This may take a while"
    puts
    
    try_solve(0)

    self
  end
  

  def debug_wait
    if @debug
      puts @puzzle

      puts "Waiting to go ahead. Hit enter."
      STDIN.gets
    end
  end


  # Brute force solution to solve the puzzle starting at index.
  def try_solve(index)
    #TODO:REMOVE ME AND PUT IN VERBOSE OUTPUT!
    #puts @puzzle

    # TODO: Output the index we're solving.
    puts "index: #{index}" if @debug

    # If we've completed the entire puzzle, we want to make sure it's been validly solved.
    if index == (@base::N**2)
      return @puzzle.solved?
    end

    # Get the row and column numbers for this cell's base index.
    row_num = index_to_row(index)
    col_num = index_to_col(index)
    #TODO:
    puts "row_num, col_num: #{row_num}, #{col_num}" if @debug
    
    cell = @puzzle.cell(row_num, col_num)
    #TODO:
    puts "cell: #{cell}" if @debug

    # If the cell is blank, we need to process it.
    if cell.blank?
      # Keep track of the original character so we can assign it again later if none of the
      # potential values here work out and we need to backtrack through the puzzle.
      original_char = cell.char

      # List of potential values that this index could be.
      p_vals = potential_values(index)
      puts "Potential values: #{p_vals}\n\n" if @debug

      #TODO:
      if p_vals.empty? and @debug
        puts "No possible values here. Backtracking.\n\n"
        debug_wait
      end
      #/TODO:
      # If there are no potential values, we have an invalid solution.
      # Returning false lets us backtrack.
      return false if p_vals.empty?

      #TODO:
      debug_wait
      # For each of the potential values, we try assinging the value here 
      # and solving the rest of the puzzle with this guess.
      p_vals.each do |p_val|
        # Set this cell to the potential value.
        cell.char = p_val

        # And try to solve the rest of the puzzle.
        result = try_solve(index.next)
        # If the guess worked out, then we're done solving because we have a valid solution.
        if result
          return true

        # Guess didn't work out, so we try the next potential value.
        else
          cell.char = original_char
          #TODO:
          if @debug
            puts "Value of #{p_val} for index #{index} didn't work. Trying next one.\n\n"
            debug_wait
          end
          #/TODO:
          next
        end
      end

      #TODO:
      if @debug
        puts "Ran out of values to try for index #{index}. Backtracking.\n\n"
        debug_wait
      end

      #/TODO:
      # If we didn't solve the puzzle with these values, some value before us is wrong.
      # Resets the value here to be blank so it can be changed later.
      cell.char = original_char
      # Return false so we can backtrack and try other values in previous cells.
      return false

    # If the cell isn't blank, we process the next cell.
    else
      #TODO:
      debug_wait if @debug
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
    row = index / @base::N
  end


  # Maps cell index to column number.
  def index_to_col(index)
    column = index % @base::N
  end


  # Maps cell index to nonet number.
  def index_to_nonet(index)
    # Get the row and column for the cell.
    row = index_to_row(index)
    col = index_to_col(index)

    # Determine which nonet range includes this cell's row.
    nonet_row = 0
    @base::NONET_RANGES.each_with_index do |row_range, row_index|
      if row_range.include?(row)
        nonet_row = row_index
        break
      end
    end

    # Determine which nonet range includes this cell's column.
    nonet_col = 0
    @base::NONET_RANGES.each_with_index do |col_range, col_index|
      if col_range.include?(col)
        nonet_col = col_index
        break
      end
    end

    # Map the nonet row and column to a nonet index.
    nonet_num = (nonet_row * @base::NONET_SIZE) + nonet_col
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
    potential_vals = @base::VALUES - house_vals

    potential_vals.sort!
  end


  private :try_solve, :potential_values
end
