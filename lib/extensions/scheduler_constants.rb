module SchedulerConstants
  module Application
    NAME = 'Custom Scheduler'
  end

  module RepeatUnit
    NONE = 0
    YEARLY = 1
    MONTHLY = 2
    DAILY = 3
    HOURLY = 4
    MINUTES = 5
    ALL = {
      'none' => NONE,
      'yearly' => YEARLY,
      'monthly' => MONTHLY,
      'daily' => DAILY,
      'hourly' => HOURLY,
      'minutes' => MINUTES
    }
  end

  module RegularExp
    FIXED_DATETIME = /([\d*]{4})-([\d*]{2})-([\d*]{2})\s([\d*]{2}):([\d*]{2})/
  end
end