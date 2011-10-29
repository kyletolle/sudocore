require 'optparse'

# Parses the command line switches and returns options and the file.
class CommandLineParser
  attr_reader :file
  
  # Text describing how to run the program.
  USAGE_TEXT = "Usage: ruby #{File.basename(__FILE__)} [options] file";  


  # Set up the command line parser.
  def initialize
    # Hold the parsed options.
    @options = {}
   
    # Define the options and their uses.
    @optparse = OptionParser.new do |opts|
      # Set a banner message at the top of the help screen.
      opts.banner = USAGE_TEXT
   
      #TODO: Need to handle invalid options and the exceptions thrown by OptionParser.
      #TODO: Perhaps use a flag here for whether it's numeric or hex.
      #TODO: Option here for verbose output. Maybe even debugger, which would
      #step through each iteration and make you hit enter to advance.
      #TODO: Option to output start and stop times.
   
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
    if not ARGV.size == 1
      puts USAGE_TEXT
      exit
    end
   
    # The file is the argument left after parsing.
    @file = ARGV[0]

    self
  end
end
