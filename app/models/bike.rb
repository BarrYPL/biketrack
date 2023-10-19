class Bike < ApplicationRecord
    belongs_to :userInfo
    has_many :chains
end
