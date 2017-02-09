class CreateBankGuarantees < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_guarantees do |t|
      t.boolean :active
      t.integer :transaction_id
      
      t.timestamps
    end
  end
end
