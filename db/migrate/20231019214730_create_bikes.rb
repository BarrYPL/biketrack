class CreateBikes < ActiveRecord::Migration[7.0]
  def change
    create_table :bikes do |t|
      t.string :bike_name
      t.string :brand
      t.integer :user_info_id
      t.string :bike_id
      t.boolean :primary, default: false
      t.integer :resource_state
      t.float :distance
      t.string :brand_name
      t.string :bike_model_name
      t.integer :frame_type
      t.text :description, default: "Default Bike."
      t.timestamps
    end
  end
end
