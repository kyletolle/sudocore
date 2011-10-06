class Cell

  def initialize(char)
    #
    #TODO: Check to see if char matches the digit or blank regexes.
    #If so, store it. If not, raise error.
    #
    #TODO: How do we see what base the Cell should be in based on Sudoku's base?
    if char =~ Sudoku::DEC_REGEX or char =~ Sudoku::BLANKS_REGEX
      # Make all blank characters a period for readability in output.
      if char =~ Sudoku::BLANKS_REGEX
        char.replace(".")
      end
      @char = char
    else
      raise ArgumentError, "Each character of the Sudoku puzzle's cells must be a valid character or blank entry."
    end

  end


  def blank?

    #TODO: How do we see what base the Cell should be in based on Sudoku's base?
    return @char =~ Sudoku::BLANKS_REGEX # whether char matches blanks regex

  end


  def to_s

    @char.to_s

  end

end
