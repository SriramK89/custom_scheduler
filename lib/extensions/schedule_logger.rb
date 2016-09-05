class ScheduleLogger < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.to_formatted_s(:db)} #{severity} #{progname} #{msg}\n"
  end
end

logfile = File.open("#{Rails.root}/log/scheduler.log", 'a')  # create log file
logfile.sync = true  # automatically flushes data to file
SCHEDULE_LOGGER = ScheduleLogger.new(logfile)  # constant accessible anywhere