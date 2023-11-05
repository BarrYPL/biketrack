class Bike < ApplicationRecord
    belongs_to :user_info
    has_many :chains, dependent: :destroy
    has_many :bike_services, dependent: :destroy

    #show user's bikes
    scope :only_user_bikes, -> { where(user_info_id: session[:current_user_id]) }

    #show bike's active chain
    validate :only_one_active_chain

    private

    def only_one_active_chain
        if self.chains.active_chain.count > 1
            errors.add(:chains, "Only one chain can be active at a time.")
            return false
        else
            return true
        end
    end
end
