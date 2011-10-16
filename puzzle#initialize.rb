class Puzzle
  #TODO: How can I make options optional and also a hash?
  # Parses sudoku puzzle file and builds data structure for solving.
  # @parm string file path to file containing sudoku puzzle
  #TODO: @parm for options
  def initialize(filename)
    
    #TODO: Add whether we want to use decimal or hex digits.
    @digit_regex = DEC_REGEX

    # Characters to represent valid blank characters in the puzzle
    @blank_regex = BLANKS_REGEX

    ## Read and parse in the puzzle now
    ##
    #TODO: I think I'll want to use a puzzle class to abstract things away.
    @puzzle = [] #Puzzle.new
    @current_row = nil

    # Read in the file with the puzzle
    File.open(filename) do |file|
      file.each do |line|
        line.chomp.each_char do |char| 
          # Add this cell to the puzzle
          add_cell(Cell.new(char))
        end

        add_row
      end
    end

    # Catch argument errors
    rescue ArgumentError => e
      puts "Error: #{e.message}"
      exit
    
    # Catch file format errors
    rescue RuntimeError => e
      puts "Error: #{e.message}"
      exit

    ## Catch file errors ##
    ##
    rescue Errno::ENOENT
      puts "Error: Couldn't find the sudoku file."
      exit
    
    rescue Errno::EACCES
      puts "Error: Access denied when accessing the sudoku file."
      exit

    rescue Errno::EISDIR
      puts "Error: Given sudoku file was actually a directory, not a file."
      exit
    exit

    @puzzle.each do |row| p row end
  end
  
end
