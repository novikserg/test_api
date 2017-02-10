class AddCompanyIdToBankGuarantees < ActiveRecord::Migration[5.0]
  def change
    add_column :bank_guarantees, :company_id, :integer
  end
end
