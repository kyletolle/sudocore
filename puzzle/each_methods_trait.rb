module Puzzle::EachMethodsTrait
  as_trait do
    # Yields each cell in the puzzle
    def each
      # Yield each cell of each row in the array
      @puzzle.each do |row|
        row.each do |cell|
          yield cell
        end
      end
    end
  
  
    # Yields houses that represent each row in the puzzle
    def each_row
      @puzzle.each do |row|
        yield row
      end
    end
  
  
    # Yields houses that represent each column in the puzzle
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
  
  
    # Yields houses that represent each nonet in the puzzle
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

  end
end
