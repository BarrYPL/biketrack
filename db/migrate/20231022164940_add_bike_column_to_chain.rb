class AddBikeColumnToChain < ActiveRecord::Migration[7.0]
  def change
    add_column :chains, :bike, :string
  end
end
