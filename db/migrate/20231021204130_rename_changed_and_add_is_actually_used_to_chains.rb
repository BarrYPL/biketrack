class RenameChangedAndAddIsActuallyUsedToChains < ActiveRecord::Migration[7.0]
  def change
    class RenameChangedAndAddIsActuallyUsedToChains < ActiveRecord::Migration[6.0]
      def change
        # That was rly stupid 
        rename_column :chains, :changed, :changed_timestamp
        add_column :chains, :is_actually_used, :boolean
      end
    end
  end
end
