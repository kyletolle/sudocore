# Adds the to_s method to Puzzle.
module Puzzle::OutputTrait
  as_trait do

    # Returns string representation of sudoku puzzle for printing.
    # @return string
    def to_s
      # Make a pretty string of the puzzle.
      pretty_puzzle = 
        # Format each row.
        @puzzle.each_with_index.inject("") do |puzzle_string, (row, row_num)|

          # Put a grid in between the rows of nonets.
          row_sep = ""
          # Check if this row is a multiple of the nonet size and not the last row.
          if (row_num+1) % @base::NONET_SIZE == 0 and row_num < @base::N-1
            # For nonet size times, we want to add...
            @base::NONET_SIZE.times do |nonet|
              # ...nonet size times hyphens...
              @base::NONET_SIZE.times do
                row_sep += " -"
              end
              # ...and a plus sign, unless it's the last nonet.
              row_sep += " +" unless nonet == @base::NONET_SIZE-1
            end
            # We want to have
            row_sep += "\n"
          end

          # Format each cell.
          row.each_with_index.inject(puzzle_string) do |row_string, (cell, cell_num)|

            # Put a grid between the columns of nonets.
            # Check if this column is a multiple of nonet size and not the last column.
            if (cell_num+1) % @base::NONET_SIZE == 0 and cell_num < @base::N-1
              sep = " |"
            else
              sep = ""
            end

            # Blank cells are output as periods to increase readability.
            if cell.blank?
              cell_string = "."

            # Non-blank cells aren't changed at all.
            else
              cell_string = @base::OUTPUT[cell.to_i]
            end

            # Add this cell's value to the current row's string, with formatting as needed.
            row_string + " " + cell_string + sep

          # We want each row to be on it's own newline.
          end + "\n" + row_sep

        end

      pretty_puzzle + "\n"
    end

  end
end
