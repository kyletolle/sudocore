# Data structure to represent an individual cell in the puzzle.
class Cell
  attr_reader :char


  # Create a cell with the given character.
  # The character must be in the puzzle's base.
  def initialize(char)
    self.char = char
  end


  # Set the Cell's character.
  # The character must be in the puzzle's base.
  def char=(val)
    @char = val.to_s
  end


  # Return whether the cell is blank or not.
  def blank?
    # Return whether the cell is a blank entry.
    return char =~ Puzzle::BLANKS_REGEX
  end


  def valid?
    #TODO: Check to see if char matches the digit or blank regexes.
    #TODO: How do we see what base the Cell should be in based on Sudoku's base?
    unless char =~ Puzzle::DECIMAL_REGEX or char =~ Puzzle::BLANKS_REGEX
      raise ArgumentError, "Each character of the Sudoku puzzle's Cells must be a valid character or blank entry."
    end
  end


  # Convert a cell to a string.
  def to_s
    char.to_s
  end


  # Convert a cell to an integer.
  # Blank cells will return 0.
  def to_i
    char.to_i
  end


  # Returns the comparison of one cell to another.
  # Allows sorting of cells.
  def <=>(other)
    # Spaceship operator of the cell is the spaceship operator of the character.
    char <=> other.char
  end


  ## The following functions are needed for Array#uniq to work on an array of cells.
  ##

  # Returns the hash of the cell.
  def hash
    # Hash of the cell is the hash of the character.
    char.hash
  end


  # Returns whether the cell is equal to the other cell.
  def eql?(comparee)
    self == comparee
  end


  # Returns whether the cell is equal to the other cell.
  def ==(comparee)
    # A cell is equal to another if the cell's characters are equal.
    char == comparee.char
  end


end
