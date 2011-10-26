# Adds the to_s method to Puzzle.
module Puzzle::OutputTrait
  as_trait do
    # Returns string representation of sudoku puzzle for printing
    # @return string
    def to_s
      
      # Make a pretty string of the puzzle
      pretty_puzzle = 
        # Format each row
        @puzzle.each_with_index.inject("") do |puzzle_string, (row, row_num)|
  
          # Put a grid in between the rows of nonets.
          if (row_num+1) % 3 == 0 and row_num < 8
            row_sep = " - - - + - - - + - - -\n"
          else
            row_sep = ""
          end
    
          # Format each cell
          row.each_with_index.inject(puzzle_string) do |row_string, (cell, cell_num)|
  
              # Put a grid between the columns of nonets.
              if (cell_num+1) % 3 == 0 and cell_num < 8
                sep = " |"
              else
                sep = ""
              end
    
              # Add this cell's value to the current row's string, with formatting as needed.
              row_string + " " + cell.to_s + sep
  
            # We want each row to be on it's own newline.
            end + "\n" + row_sep
  
        end
    
      pretty_puzzle + "\n"
    
    end
  end
end
