class BikeServicesController < ApplicationController
  before_action :set_bike_service, only: %i[ show edit update destroy ]
  before_action :set_bike, only: [:index, :new, :show ]
  before_action :set_chain, only: [:index, :new, :show ]

  # GET /bike_services or /bike_services.json
  def index
    @bike_services = BikeService.all
  end

  # GET /bike_services/1 or /bike_services/1.json
  def show
  end

  # GET /bike_services/new
  def new
    @bike_service = BikeService.new
  end

  # GET /bike_services/1/edit
  def edit
  end

  # POST /bike_services or /bike_services.json
  def create
    @bike_service = BikeService.new(bike_service_params)

    respond_to do |format|
      if @bike_service.save
        format.html { redirect_to bike_service_url(@bike_service), notice: "Bike service was successfully created." }
        format.json { render :show, status: :created, location: @bike_service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bike_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bike_services/1 or /bike_services/1.json
  def update
    respond_to do |format|
      if @bike_service.update(bike_service_params)
        format.html { redirect_to bike_service_url(@bike_service), notice: "Bike service was successfully updated." }
        format.json { render :show, status: :ok, location: @bike_service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bike_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bike_services/1 or /bike_services/1.json
  def destroy
    @bike_service.destroy

    respond_to do |format|
      format.html { redirect_to bike_services_url, notice: "Bike service was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bike_service
      @bike_service = BikeService.find(params[:id])
    end

    def set_bike
      @bike = Bike.find_by(id: params['bike'])
      @bike ||= Bike.find_by(id: params['id'])
      if @bike.nil?
        redirect_to homepage_url, alert: "You probably doesn't have bikes added yet."
      end
    end

    def set_chain
      @chain = @bike.chains.active_chain
    end

    # Only allow a list of trusted parameters through.
    def bike_service_params
      params.require(:bike_service).permit(:service_name, :service_date, :service_description, :bike_id)
    end
end
