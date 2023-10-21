class CreateChains < ActiveRecord::Migration[7.0]
  def change
    create_table :chains do |t|
      t.string :name
      t.integer :vaxed_timestamp
      t.integer :changed_timestamp
      t.integer :kmoffset
      t.boolean :is_actually_used

      t.timestamps
    end
  end
end
