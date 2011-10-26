# Adds row/column/nonet methods to Puzzle.
module Puzzle::HousesTrait
  as_trait do
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
  end
end
