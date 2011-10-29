# Tracks the time it took to solve the puzzle.
# Set to_log to true to log out solved duration.
# Set verbose to true to log out the start and solve times.
class Timer
  # Want to log time in "HH:MM:SS AM/PM" format
  TIME_FORMAT = "%I:%M:%S%p"
  

  # Create the timer.
  # Set to_log to true to log out solved duration.
  # Set verbose to true to log out start and end times.
  def initialize(to_log = false, verbose = false)
    @to_log = to_log
    @verbose = verbose
  end


  # Records time puzzle is started.
  # Will write to console if user configures timer to.
  def start
    @start_time = Time.now
    # Only log starting puzzle time if user wants verbose logging.
    puts "Solving puzzle at #{@start_time.strftime(TIME_FORMAT)}.\n\n" if @to_log and @verbose
  end


  # Records time the puzzle is solved.
  # Will write to console if user configures timer to.
  def stop
    @end_time = Time.now

    # Only log solved puzzle time if user wants verbose logging.
    puts "Solved puzzle at #{@end_time.strftime(TIME_FORMAT)}.\n\n" if @to_log and @verbose

    # Solved duration if the user wants logging.
    puts "Puzzle solved in #{@end_time - @start_time} seconds.\n\n" if @to_log
  end
end

