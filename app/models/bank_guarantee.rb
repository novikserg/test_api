class BankGuarantee < ActiveRecord::Base
  validates_presence_of :transaction_id, :company_id
  validates_inclusion_of :active, in: [true, false]

  belongs_to :current_transaction, foreign_key: "transaction_id", class_name: "Transaction"
  belongs_to :company
  
  def deactivate!
    self.active = false
    save
  end
end
