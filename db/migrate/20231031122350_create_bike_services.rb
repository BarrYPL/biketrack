class CreateBikeServices < ActiveRecord::Migration[7.0]
  def change
    create_table :bike_services do |t|
      t.string :service_name
      t.string :service_description
      t.date :service_date
      t.integer :bike_id
      t.timestamps
    end
  end
end