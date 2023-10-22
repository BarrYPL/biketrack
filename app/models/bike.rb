class Bike < ApplicationRecord
    belongs_to :user_info
    has_many :chains
end
