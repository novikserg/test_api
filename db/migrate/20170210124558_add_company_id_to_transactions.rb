class AddCompanyIdToTransactions < ActiveRecord::Migration[5.0]
  def change
    add_column :transactions, :company_id, :integer
  end
end
