class UserInfo < ApplicationRecord
    has_many :bikes, dependent: :destroy
end
