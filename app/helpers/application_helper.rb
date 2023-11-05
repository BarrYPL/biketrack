module ApplicationHelper
    def km_since_last_vaxking(chain)
        unless chain.nil?
            unless chain.vaxed_timestamp.nil?
                #sum all km from vaxing date to now on specified bike
                return (Ride.where(gear_id: chain.bike.bike_id).where("timestamp > ?", chain.vaxed_timestamp).sum(:distance).to_f / 1000.0).round(2)
            end
        end
    end

    def set_bike
        @bike = Bike.find_by(id: params['bike'])
        
        binding.pry
        
        if @bike.nil?
          redirect_to homepage_url, alert: "You probably doesn't have bikes added yet."
        end
      end
end
