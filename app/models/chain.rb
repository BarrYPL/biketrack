class Chain < ApplicationRecord
    belongs_to :bike
    before_save :update_chain_status

    scope :active_chain, -> { where(is_actually_used: true)}

    private
  
    def update_chain_status
        if self.instalation_date_changed?
            self.bike.chains.where.not(id: self.id).update_all(is_actually_used: false)
            last_changed_chain = self.bike.chains.order(:instalation_date).first
            binding.pry
            last_changed_chain.update(is_actually_used: true) if last_changed_chain
        end
    end
end
