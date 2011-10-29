# An abstract class for algorithms that can solve sudoku puzzles.
class Algorithm
  # The algorithm is in charge of solving the puzzle, but is implemented in children classes.
  def solve(puzzle)
    raise NotImplementedError, "Subclass must implement this method."
  end
end
