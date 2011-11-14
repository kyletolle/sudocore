require 'optparse'
require 'ostruct'

# Parses the command line switches and returns options and the file.
class CommandLineParser
  # Parse in the optional command line switches and check for the required file.
  def parse!
    # Hold the parsed options.
    options = OpenStruct.new

    # Set defaults for options.
    options.base = :dec
    options.file = ''
    options.debug = false
    options.time = false
    options.verbose = false

    # Define the options and their uses.
    optparse = OptionParser.new do |opts|
      # Set a banner message at the top of the help screen describing how to run the program.
      opts.banner = "Usage: ruby sudocore.rb [options] file"

      opts.separator ""
      opts.separator "Specific options:"

      # TODO:Get this working
      # Sets the base of the puzzle.
      opts.on('-b', "--base [BASE]", [:dec, :hex], "TODO:Select puzzle base (dec, hex)") do |b|
        options.base = b
      end

      # Whether the user wants to step through the algorithm.
      opts.on('-d', '--debug', "Algorithm used to solve puzzle will prompt user to ",
                               "  proceed after each iteration of solving and show the ",
                               "  current state of the puzzle.") do |d|
        options.debug = d
      end

      # Outputs more information when solving the puzzle.
      opts.on('-v', '--verbose', "Output verbosely while running.") do |v|
        options.verbose = v
      end

      opts.separator ""
      opts.separator "Common options:"

      # Outputs time information. Combine with verbosity for even more info.
      opts.on('-t', '--time', "Print out the time it took to solve the puzzle.",
                              "  Combine with --verbose for start/solve times.") do |t|
        options.time = t
      end

      # Displays the help screen.
      opts.on_tail('-h', '--help', 'Display this help screen') do
        puts opts
        exit
      end

      # Prints out the version number of Sudocore.
      opts.on_tail("--version", "TODO:Show version") do
      end
    end


    # Parse the command line, removing any options, leaving the filename we want.
    optparse.parse!

    # If we don't have a file after the options, show the usage text and exit.
    if ARGV.size < 1
      raise ArgumentError, "Missing required file."
    elsif ARGV.size > 1
      raise ArgumentError, "Too many arguments."
    end

    # The file is the argument left after parsing.
    options.file = ARGV[0]

    options

  # Any errors raised from pasring command line will output the error message,
  # print the usage text and then exit program.
  rescue => e
    puts "Error: #{e.message}\n\n"
    puts optparse
    exit
  end
end
