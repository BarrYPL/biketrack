class AddUniqueConstraintToRideId < ActiveRecord::Migration[7.0]
  def change
    add_index :rides, :ride_id, unique: true
  end
end
