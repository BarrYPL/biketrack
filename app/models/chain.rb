class Chain < ApplicationRecord
    belongs_to :bike
    scope :active_chain, -> { where(is_actually_used: true)}
    
end
