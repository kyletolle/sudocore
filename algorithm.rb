# An abstract class for algorithms that can solve sudoku puzzles.
class Algorithm
  def solve
    raise NotImplementedError, "Subclass must implement this method."
  end
end
