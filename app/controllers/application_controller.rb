class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected
    def get_js_variables options = {}
      if options[:repeat_units]
        gon.repeat_units = {
          none: SchedulerConstants::RepeatUnit::NONE,
          yearly: SchedulerConstants::RepeatUnit::YEARLY,
          monthly: SchedulerConstants::RepeatUnit::MONTHLY,
          daily: SchedulerConstants::RepeatUnit::DAILY,
          hourly: SchedulerConstants::RepeatUnit::HOURLY,
          minutes: SchedulerConstants::RepeatUnit::MINUTES
        }
      end
    end
end
