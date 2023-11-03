class CreateBikeServices < ActiveRecord::Migration[7.0]
  def change
    create_table :bike_services do |t|

      t.timestamps
    end
  end
end
