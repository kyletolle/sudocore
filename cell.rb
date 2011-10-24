# Data structure to represent an individual Cell in the puzzle
class Cell

  # We need other Cell objects to read the char for sorting to work
  attr_reader :char
  protected :char

  # Set the Cell's character
  def char=(val)
    #TODO: Add in error checking?
    @char = val.to_s
  end

  # Create a Cell with the given character
  def initialize(char)

    #TODO: Check to see if char matches the digit or blank regexes.
    #If so, store it. If not, raise error.
    #
    #TODO: How do we see what base the Cell should be in based on Sudoku's base?
    if char =~ Puzzle::DECIMAL_REGEX or char =~ Puzzle::BLANKS_REGEX
      # Make all blank characters a period for readability in output.
      if char =~ Puzzle::BLANKS_REGEX
        char.replace(".")
      end
      self.char = char
    else
      raise ArgumentError, "Each character of the Sudoku puzzle's Cells must be a valid character or blank entry."
    end

  end


  # Return whether the Cell is blank or not
  def blank?
    #TODO: How do we see what base the Cell should be in based on Sudoku's base?
    return char =~ Puzzle::BLANKS_REGEX # whether char matches blanks regex
  end


  # Convert a Cell to a string
  def to_s
    char.to_s
  end


  # Convert a Cell to an integer
  def to_i
    char.to_i
  end

  
  # Allows sorting of Cells
  def <=>(other)
    char <=> other.char
  end


  ## The following functions are needed for Array#uniq to work on an array of Cells
  ##

  # Returns the hash of the Cell
  def hash
    # Hash of the Cell is the hash of the character.
    char.hash
  end

  
  # Returns whether the Cell is equal to the other Cell.
  def eql?(comparee)
    self == comparee
  end


  # Returns whether the Cell is equal to the other Cell.
  def ==(comparee)
    # A Cell is equal to another if the Cell's characters are equal.
    char == comparee.char
  end

end
