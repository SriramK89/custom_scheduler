class SchedulersController < ApplicationController
  before_action :set_scheduler, only: [:show, :edit, :update, :destroy]

  # GET /schedulers
  # GET /schedulers.json
  def index
    @schedulers = Scheduler.all
  end

  # GET /schedulers/1
  # GET /schedulers/1.json
  def show
  end

  # GET /schedulers/new
  def new
    @scheduler = Scheduler.new
    get_js_variables(repeat_units: true)
  end

  # GET /schedulers/1/edit
  def edit
    get_js_variables(repeat_units: true)
  end

  # POST /schedulers
  # POST /schedulers.json
  def create
    @scheduler = Scheduler.new(scheduler_params)
    get_js_variables(fixed_datetime_regex: true)

    respond_to do |format|
      @scheduler.fixed_datetime = @scheduler.compute_fixed_time(params.slice(:year, :month, :day, :hour, :minute))
      if @scheduler.save
        format.html { redirect_to @scheduler, notice: 'Scheduler was successfully created.' }
        format.json { render :show, status: :created, location: @scheduler }
      else
        format.html { render :new }
        format.json { render json: @scheduler.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /schedulers/1
  # PATCH/PUT /schedulers/1.json
  def update
    get_js_variables(fixed_datetime_regex: true)
    respond_to do |format|
      @scheduler.fixed_datetime = @scheduler.compute_fixed_time(params.slice(:year, :month, :day, :hour, :minute))
      @scheduler.assign_attributes(scheduler_params)
      has_changed = @scheduler.changed?
      if @scheduler.save
        @scheduler.reset_history if has_changed
        format.html { redirect_to @scheduler, notice: 'Scheduler was successfully updated.' }
        format.json { render :show, status: :ok, location: @scheduler }
      else
        format.html { render :edit }
        format.json { render json: @scheduler.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /schedulers/1
  # DELETE /schedulers/1.json
  def destroy
    @scheduler.destroy
    respond_to do |format|
      format.html { redirect_to schedulers_url, notice: 'Scheduler was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scheduler
      @scheduler = Scheduler.where(id: params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scheduler_params
      params.require(:scheduler).permit(:repeat_unit, :repeat_number)
    end
end
