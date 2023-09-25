class AddRideIdToRides < ActiveRecord::Migration[7.0]
  def change
    add_column :rides, :ride_id, :integer
  end
end
