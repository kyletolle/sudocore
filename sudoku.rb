class Sudoku
  
  DEC_REGEX = /^[0-9]$/
  HEX_REGEX = /^[a-zA-z0-9]$/
  BLANKS_REGEX = /^[_\.]$/

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

    #TODO:
    puts "BEGIN SOLVING!"
    puts self.to_s
    #/TODO
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

  
  # Map an index in the range 0..80 to the row and column indices for the puzzle
  def index_to_indices(index)

    row    = index / 9;
    column = index % 9;

    return row, column

  end

  
  #TODO: Do we need to check in the values_in_* functions for uniq values?
  # Return sorted array of non-blank values in this cell's row
  def values_in_row(row_num)

    # Only select the elements from the row that aren't blank, then sort it
    row_vals =
      @puzzle[row_num].select do |val|
        not val.blank?
      end.sort!

    # Convert the array of cells to an array of integers
    row_vals.map! {|cell| cell.to_i }
    
  end


  # Return sorted array of non-blank values in this cell's column
  def values_in_col(col_num)

    # Iterate over all rows to get the specific column values and
    # only select these values if they aren't blank, then sort it.
    col_vals =
      @puzzle.map {|row| row[col_num] }.select {|val| not val.blank?}.sort!

    # Convert the array of cells to an array of integers
    col_vals.map! {|cell| cell.to_i }

  end


  # Return array of non-blank values in this cell's nonet
  def values_in_nonet(row_num, col_num)

    # Which range the row is in
    case row_num
    when 0..2
      row_range = 0..2
    when 3..5
      row_range = 3..5
    when 6..8
      row_range = 6..8
    end

    # Which range the column is in
    case col_num
    when 0..2
      col_range = 0..2
    when 3..5
      col_range = 3..5
    when 6..8
      col_range = 6..8
    end
    
    # The combination of row and column ranges gives the nonet for this cell.

    vals = []

    # Loop over the row range and column range in those rows for the nonet values
    # Only interested in the non-blank values.
    row_range.each do |row|
      col_range.each do |col|
        cell = @puzzle[row][col]
        vals << cell unless cell.blank?
      end
    end
    
    # Sort the vals array
    vals.sort!

    # Convert the array of cells to an array of integers
    vals.map! {|cell| cell.to_i }

  end


  # Return a sorted, unique list of the possible values the cell at
  # puzzle's index position could be.
  def potential_values(index)

    ## Check the cells house for values we can't be
    ## and eliminate them from the values that we can be.
    ## So we are left with only a list of potential values
    ##
    row_num, col_num = index_to_indices(index)

    row_vals = values_in_row(row_num)

    col_vals = values_in_col(col_num)

    nonet_vals = values_in_nonet(row_num, col_num)

    # Merge the row, column and nonet values into a unique, sorted list.
    house_vals = (row_vals | col_vals | nonet_vals).uniq.sort!

    all_vals = (1..9).to_a

    # Potential values for this cell are all the values that don't conflict
    # with the actual values of other cells in this cell's house.
    potential_vals = all_vals - house_vals

  end


  #TODO: Doesn't work on a blank puzzle...
  def try_solve(index)
    #TODO:REMOVE ME!
    #print_on = [0]
    #if print_on.include?(index)
    #  puts self.to_s
    #end
    #puts "Waiting to go ahead"
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
    
    #TODO:REMOVE ME!
    #puts "Solving for Index: #{index}"
    row, col = index_to_indices(index)
    
    cell = @puzzle[row][col]

    #TODO: Need to figure out why this algorithm doesn't seem to be working.
    if cell.blank?
      p_vals = potential_values(index)

#TODO:REMOVE ME!
#if p_vals.empty?
  #puts "No potential values for @puzzle[#{row}][#{col}]"
  #TODO:REMOVE ME!
  #puts self.to_s
#end
#/TODO
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

      #TODO:RESET THE VALUE HERE TO BE BLANK AGAIN!
      cell.char = "."
      return false

    else
      if index.next == (9*9)
        return solved?
      end

      try_solve(index.next)
    end

  end


  def valid?

    unless @puzzle.size == 9
      raise RuntimeError, "Sudoku puzzle must have 9 rows."
    end

    return true #TODO: Find out if there are conflicts in row, column or nonet.

  end


  def solved?
    #TODO:REMOVE ME!
    puts "Checking to see if puzzle is solved!"
    #TODO: A puzzle is solved if each of the rows, columns and nonets have the values 1-9.
    # Check to see if all the rows are valid
    #TODO: Have a function that returns each row of the puzzle.
    @puzzle.each do |row|
      row_value = row.inject(0) {|sum, cell| sum + cell.to_i }
 
      # All rows must sum up t 45 if they are valid.
      unless row_value == 45
        puts "Invalid row sum!"
        return false
      end
    end

    # Check to see if all the columns are valid
    #TODO: Have a function that returns each column of the puzzle
    # This is the column number
    (0..8).each do |col_num|
      col_sum = 0
      # We want to get the column indices from each row
      (0..8).each do |row_num|
        # Sum them up
        col_sum += @puzzle[row_num][col_num].to_i
      end

      # All columns must sum to 45 if they are valid.
      unless col_sum == 45
        puts "Invalid column sum!"
        return false
      end
    end
    
    # Check to see if all the nonets are valid
    #TODO: Have a function that returns each nonet of the puzzle
    #
    
    #TODO:REMOVE THIS
    # Check if any of the cells are still blank.
    @puzzle.each do |row|
      row.each do |cell|
        return false if cell.blank?
      end
    end
    true
  end

  private :add_row, :add_cell, :try_solve, :valid?, :index_to_indices
end
