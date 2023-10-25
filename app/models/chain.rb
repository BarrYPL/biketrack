class Chain < ApplicationRecord
    belongs_to :bike
    after_save :update_chain_status

    scope :active_chain, -> { where(is_actually_used: true)}

    private
  
    def update_chain_status
        if self.changed_timestamp_changed?
            self.bike.chains.update_all(is_actually_used: false)
            last_changed_chain = self.bike.chains.order(:changed_timestamp).first
            last_changed_chain.update(is_actually_used: true) if last_changed_chain
        end
    end
end
