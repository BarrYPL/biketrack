class Chain < ApplicationRecord
    belongs_to :bike
    before_save :update_chain_status
    after_save :uptade_active_chain

    scope :active_chain, -> { where(is_actually_used: true)}

    private
  
    def update_chain_status
 #       if self.instalation_date_changed?
 #           self.bike.chains.where.not(id: self.id).update_all(is_actually_used: false)
 #       end
    end

    def uptade_active_chain
        if self.is_actually_used_changed?
            if self.is_actually_used
                self.bike.chains.where.not(id: self.id).update_all(is_actually_used: false)
            else
                self.bike.chains.order(:instalation_date).first.update(is_actually_used: true)
            end
        end
    end
end
