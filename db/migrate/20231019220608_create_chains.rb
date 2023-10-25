class CreateChains < ActiveRecord::Migration[7.0]
  def change
    create_table :chains do |t|
      t.string :chain_name
      t.datetime :vaxed_timestamp
      t.datetime :changed_timestamp
      t.integer :kmoffset
      t.boolean :is_actually_used, default: false

      t.timestamps
    end
  end
end
