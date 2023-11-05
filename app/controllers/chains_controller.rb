class ChainsController < ApplicationController
  before_action :set_chain, only: %i[ show edit update destroy ]
  before_action :set_bike, only: [:index, :new, :show ]
  before_action :selected_chain, only: [:show, :index]
  before_action :prepare_chart, only: [:show]

  # GET /chains or /chains.json
  def index
    @chains = Chain.all
    @chains_km = Hash.new()
    @chains.each do |chain|
      @chains_km[chain.id] = km_since_last_vaxking(chain)
    end
  end

  # GET /chains/1 or /chains/1.json
  def show
    @distance = km_since_last_vaxking(@chain)
  end

  # GET /chains/new
  def new
    @chain = Chain.new
  end

  # GET /chains/1/edit
  def edit
  end

  # POST /chains or /chains.json
  def create
    @chain = Chain.new(chain_params)
    respond_to do |format|
      if @chain.save
        update_chains_of_bike(@chain.bike)
        format.html { redirect_to chain_url(@chain), notice: "Chain was successfully created.", bike: @chain.bike }
        format.json { render :show, status: :created, location: @chain }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chains/1 or /chains/1.json
  def update
    respond_to do |format|
      if @chain.update(chain_params)
        update_chains_of_bike(@chain.bike, bike: @bike.id)
        #I need to update redirect to chain_url tomorrow.
        format.html { redirect_to chain_url(@chain), notice: "Chain was successfully updated." }
        format.json { render :show, status: :ok, location: @chain }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chains/1 or /chains/1.json
  def destroy
    @chain.destroy

    respond_to do |format|
      format.html { redirect_to chains_url, notice: "Chain was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chain
      @chain = Chain.find(params[:id])
    end

    def update_chains_of_bike(bike)
      bike.chains.update_all(is_actually_used: false)
      bike.chains.order(:instalation_date).last.update(is_actually_used: true)
    end

    def prepare_chart
      @rides = Ride.where(gear_id: @bike['bike_id']).where('timestamp > ?', @chain.vaxed_timestamp).group_by_day(:timestamp).sum(:distance)
      @cumulative_rides = @rides.transform_values.with_index { |value, index| (@rides.values[0..index].sum / 1000.0).round(0) }
    end

    def selected_chain
      @selected_chain = @bike.chains.active_chain.first
    end

    # Only allow a list of trusted parameters through.
    def chain_params
      params.require(:chain).permit(:chain_name, :chain_model, :vaxed_timestamp, :instalation_date, :kmoffset, :bike_id)
    end
end
