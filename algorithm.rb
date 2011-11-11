# An abstract class for algorithms that can solve sudoku puzzles.
class Algorithm
  # Initializes the algorithm
  # @param debug true/false Indicates whether the user wants the algorithm
  # to pause after each iteration and show the current state of the puzzle.
  def initialize(debug = false)
    @debug = debug
  end


  # The algorithm is in charge of solving the puzzle, but is implemented in children classes.
  def solve(puzzle)
    raise NotImplementedError, "Subclass must implement this method."
  end
end
