module ApplicationHelper
    def km_since_last_vaxking(chain)
        
        binding.pry
        
        unless chain.nil?
            unless chain.vaxed_timestamp.nil?
                #sum all km from vaxing date to now on specified bike
                return (Ride.where(gear_id: chain.bike.bike_id).where("timestamp > ?", chain.vaxed_timestamp.to_i).sum(:distance).to_f / 1000.0).round(2)
            end
        end
    end
end
