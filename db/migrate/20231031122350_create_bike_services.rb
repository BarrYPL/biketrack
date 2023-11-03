class CreateBikeServices < ActiveRecord::Migration[7.0]
  def change
    create_table :bike_services do |t|
      t.service_name :string
      t.service_description :string
      t.service_date :date
      t.timestamps
    end
  end
end
