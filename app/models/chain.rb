class Chain < ApplicationRecord
    belongs_to :bike
    scope :active_chain, -> { where(is_actually_used: true)}
    
    scope :km_since_vaxed, lambda {
        sum_km = Rides.where(gear_id: self.bike.bike_id).where("timestamp > ?", self.vaxed_timestamp.to_i).sum(:distance)
        if sum_km.nil?
            return 0
        else
            return (sum_km.to_f / 1000.0).round(2)
        end
    }
end
