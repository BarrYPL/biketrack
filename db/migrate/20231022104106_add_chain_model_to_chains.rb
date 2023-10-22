class AddChainModelToChains < ActiveRecord::Migration[7.0]
  def change
    add_column :chains, :chain_model, :string
  end
end
