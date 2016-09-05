class Scheduler < ApplicationRecord
  # VALIDATIONS
  validates :fixed_datetime, presence: true

  # CLASS METHODS
  class << self
    def no_repetition
      where.not(repeat_unit: SchedulerConstants::RepeatUnit::NONE)
    end

    def has_run
      where.not('number_of_runs = ?', 0)
    end
  end

  # INSTANCE METHODS
  def compute_fixed_time input_params
    dummy = '**'
    datetime = ''
    input_params = case repeat_unit
      when SchedulerConstants::RepeatUnit::YEARLY
        input_params.slice(:month, :day, :hour, :minute)
      when SchedulerConstants::RepeatUnit::MONTHLY
        input_params.slice(:day, :hour, :minute)
      when SchedulerConstants::RepeatUnit::DAILY
        input_params.slice(:hour, :minute)
      when SchedulerConstants::RepeatUnit::HOURLY
        input_params.slice(:minute)
      when SchedulerConstants::RepeatUnit::MINUTES
        input_params.slice()
      else
        input_params
      end
    datetime += "#{get_datetime_str(input_params[:year], dummy * 2)}-"
    datetime += "#{get_datetime_str(input_params[:month], dummy)}-"
    datetime += "#{get_datetime_str(input_params[:day], dummy)} "
    datetime += "#{get_datetime_str(input_params[:hour], dummy)}:"
    datetime += get_datetime_str(input_params[:minute], dummy)
    fixed_datetime = datetime
  end

  def reset_history
    if number_of_runs > 0
      update_attributes(last_run_at: nil, number_of_runs: 0)
    end
  end

  # PRIVATE METHODS
  private
    def get_datetime_str input_hash_val, dummy_val
      input_hash_val ? "#{format_digits(input_hash_val)}" : dummy_val
    end

    def format_digits number
      number.to_i < 10 ? "0#{number}" : number
    end
end
