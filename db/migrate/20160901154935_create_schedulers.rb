class CreateSchedulers < ActiveRecord::Migration[5.0]
  def change
    create_table :schedulers do |t|
      t.integer :repeat_unit,     default: SchedulerConstants::RepeatUnit::NONE
      t.integer :repeat_number
      t.string :fixed_datetime,   null: false
      t.timestamp :last_run_at
      t.integer :number_of_runs,  default: 0

      t.timestamps
    end
  end
end
