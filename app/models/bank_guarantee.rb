class BankGuarantee < ActiveRecord::Base
  validates :transaction_id, :active, presence: true
  belongs_to :current_transaction, foreign_key: "transaction_id", class_name: "Transaction"
end
