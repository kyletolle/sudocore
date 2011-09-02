class Sudoku
  
  /**
   * Parses sudoku puzzle file and builds data structure for solving.
   * @parm string file path to file containing sudoku puzzle
   */
  def initialize(file)
    @puzzle = []
  end

  /**
   * Solves sudoku puzzle
   */
  def solve
    
  end

  /**
   * Returns string representation of sudoku puzzle for printing
   * @return string
   */
  def to_s
    return '';
  end
end

# Need to have some stuff for printing options here.

file = "some file from the options"

sudoku = Sudoku.new(file)
sudoku.solve
puts soduku
