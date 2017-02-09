class AddDefaultToBankGuarantee < ActiveRecord::Migration[5.0]
  def change
    change_column :bank_guarantees, :active, :boolean, default: true
  end
end
