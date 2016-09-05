namespace :custom_scheduled_task do
  desc 'Run the pre schedules tasks'
  task run: :environment do
    schedules = Scheduler.no_repetition.merge(Scheduler.has_run)
    schedules = schedules.or(Scheduler.no_repetition)
    datetime_now = Time.zone.now
    SCHEDULE_LOGGER.info 'Beginning to run schedules'
    schedules.each do |schedule|
      schedule_id = schedule.id
      SCHEDULE_LOGGER.info "  Beginning to check for schedule.id => #{schedule_id}"
      repeat_unit = schedule.repeat_unit
      repeat_number = schedule.repeat_number
      last_run_datetime = schedule.last_run_at
      # year, month, day, hour, minute = schedule.fixed_datetime.match(
      #   SchedulerConstants::RegularExp::FIXED_DATETIME).captures
      should_execute = false
      case repeat_unit
        when SchedulerConstants::RepeatUnit::NONE
          should_execute = (datetime_now.strftime('%Y-%m-%d %H:%M') == schedule.fixed_datetime)
        when SchedulerConstants::RepeatUnit::YEARLY
          should_execute =   (datetime_now.strftime('****-%m-%d %H:%M') == schedule.fixed_datetime)
          if last_run_datetime
            should_execute &&= (datetime_now.year == (last_run_datetime.year + repeat_number))
          end
        when SchedulerConstants::RepeatUnit::MONTHLY
          should_execute = (datetime_now.strftime('****-**-%d %H:%M') == schedule.fixed_datetime)
          if last_run_datetime
            should_execute &&= (datetime_now.month == (last_run_datetime.month + repeat_number))
          end
        when SchedulerConstants::RepeatUnit::DAILY
          should_execute = (datetime_now.strftime('****-**-** %H:%M') == schedule.fixed_datetime)
          if last_run_datetime
            should_execute &&= (datetime_now.day == (last_run_datetime.day + repeat_number))
          end
        when SchedulerConstants::RepeatUnit::HOURLY
          should_execute = (datetime_now.strftime('****-**-** **:%M') == schedule.fixed_datetime)
          if last_run_datetime
            should_execute &&= (datetime_now.hour == (last_run_datetime.hour + repeat_number))
          end
        when SchedulerConstants::RepeatUnit::MINUTES
          should_execute = true
          if last_run_datetime
            should_execute = (datetime_now.min >= (last_run_datetime.min + repeat_number))
          end
      end
      schedule.update(last_run_at: datetime_now, number_of_runs: (schedule.number_of_runs + 1))
      SCHEDULE_LOGGER.info "  Completed the schedule.id => #{schedule.id} (#{'NOT ' if !should_execute}EXECUTED)"
    end
    SCHEDULE_LOGGER.info 'Completed running schedules'
  end

end
