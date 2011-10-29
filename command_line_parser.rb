require 'optparse'

# Parses the command line switches and returns options and the file.
class CommandLineParser
  attr_reader :file, :switches
  

  # Set up the command line parser.
  def initialize
    # Hold the parsed options.
    @switches = {}
   
    # Define the options and their uses.
    @optparse = OptionParser.new do |opts|
      # Set a banner message at the top of the help screen describing how to run the program.
      opts.banner = "Usage: ruby sudocore.rb [options] file"

      opts.on('-t', '--time', "Print out the time it took to solve the puzzle.") do |t|
        @switches[:time] = true;
      end
   
      #TODO: Perhaps use a flag here for whether it's numeric or hex.
      #TODO: Option here for verbose output. Maybe even debugger, which would
      #step through each iteration and make you hit enter to advance.
   
      # Displays the help screen.
      opts.on('-h', '--help', 'Display this help screen') do
        puts opts
        exit
      end
    end
  end


  # Parse in the optional command line switches and check for the required file.
  def parse!
    # Parse the command line, removing any options, leaving the filename we want.
    @optparse.parse!
   
    # If we don't have a file after the options, show the usage text and exit.
    if ARGV.size < 1
      raise ArgumentError, "Missing required file."
    elsif ARGV.size > 1
      raise ArgumentError, "Too many arguments."
    end
   
    # The file is the argument left after parsing.
    @file = ARGV[0]

    self

  # Any errors raised from pasring command line will output the error message,
  # print the usage text and then exit program.
  rescue => e
    puts "Error: #{e.message}\n\n"
    puts @optparse
    exit
  end
end
