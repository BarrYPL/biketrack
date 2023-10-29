class CreateRides < ActiveRecord::Migration[7.0]
  def change
    create_table :rides do |t|
      t.string :ride_name
      t.float :distance
      t.integer :athlete_id
      t.integer :moving_time
      t.date :timestamp
      t.string :gear_id
      t.float :average_speed
      t.float :max_speed
      t.float :total_elevation_gain

      t.timestamps
    end
  end
end
