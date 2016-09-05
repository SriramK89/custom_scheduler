json.extract! scheduler, :id, :repeat_unit, :repeat_number, :fixed_datetime, :last_run_at, :number_of_runs, :created_at, :updated_at
json.url scheduler_url(scheduler, format: :json)