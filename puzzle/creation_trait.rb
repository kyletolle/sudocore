# Adds the initialize method to Puzzle.
module Puzzle::CreationTrait
  as_trait do

    # Parses sudoku puzzle file and builds data structure for solving.
    # @parm string file path to file containing sudoku puzzle
    #TODO: @parm for options
    def initialize(filename, base = :dec, debug = false, verbose = false)
      #TODO: How can I make passed in options optional and also a hash?

      case base
      when :dec
        @base = Decimal
      when :hex
        @base = Hexadecimal
      end

      Cell.base = @base;

      ## Read and parse in the puzzle now.
      ##
      @puzzle = [] #Puzzle.new
      @current_row = nil

      #TODO: Allow different algorithms to be chosen.
      require './brute_force'
      @algorithm = BruteForce.new(debug, verbose)

      # Read in the file containing the puzzle.
      File.open(filename) do |file|
        # Read in each line of the file and add the row to the puzzle.
        file.each do |line|
          # Create a puzzle cell for each character of the line.
          line.chomp.each_char do |char| 
            # Add this cell to the row.
            if @base::INPUT.has_key?(char)
              add_cell(Cell.new(@base::INPUT[char]))
            else
              add_cell(Cell.new(char))
            end
          end

          # Add this row to the puzzle.
          add_row
        end
      end

      #TODO: Move this error handling to another area for consolidation.
      # Catch argument errors.
      rescue ArgumentError => e
        puts "Error: #{e.message}"
        exit

      # Catch file format errors.
      rescue RuntimeError => e
        puts "Error: #{e.message}"
        exit

      ## Catch file errors.
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
    end

  end
end
