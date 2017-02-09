class BankGuarantee < ActiveRecord::Base
  validates :transaction_id, presence: true
  validates_inclusion_of :active, in: [true, false]
  belongs_to :current_transaction, foreign_key: "transaction_id", class_name: "Transaction"
  
  def deactivate!
    self.active = false
    save
  end
end
