module SchedulersHelper
  def get_repeat_unit_options
    options = []
    SchedulerConstants::RepeatUnit::ALL.each do |key, value|
      options << [key.titlecase, value]
    end
    return options
  end

  def get_repeat_num_options repeat_unit
    options = []
    case repeat_unit
    when SchedulerConstants::RepeatUnit::YEARLY
      (1..5).map{ |year| options << [year, year] }
    when SchedulerConstants::RepeatUnit::MONTHLY
      (1..11).map{ |month| options << [month, month] }
    when SchedulerConstants::RepeatUnit::DAILY
      (1..30).map{ |day| options << [day, day] }
    when SchedulerConstants::RepeatUnit::HOURLY
      (1..23).map{ |hour| options << [hour, hour] }
    when SchedulerConstants::RepeatUnit::MINUTES
      (5..55).step(5).map{ |minute| options << [minute, minute] }
    end
    return options
  end

  def get_datetime datetime
    datetime ? datetime.strftime('%d-%m-%Y %I:%M %p %Z') : 'Not yet run!'
  end

  def get_fix_time_options dropdown_for, db_value
    options = []
    case dropdown_for
      when :year
        year_now = Time.zone.now.year
        (year_now..(year_now + 5)).map{ |year| options << [year, year] }
      when :month
        (1..12).map{ |month| options << [month, month] }
      when :day
        (1..31).map{ |day| options << [day, day] }
      when :hour
        (0..23).map{ |hour| options << [hour, hour] }
      when :minute
        (0..59).step(5).map{ |minute| options << [minute, minute] }
    end
    return options
  end
end
