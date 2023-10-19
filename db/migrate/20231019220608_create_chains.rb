class CreateChains < ActiveRecord::Migration[7.0]
  def change
    create_table :chains do |t|
      t.string :name
      t.integer :vaxed_timestamp
      t.integer :changed
      t.integer :kmoffset

      t.timestamps
    end
  end
end
