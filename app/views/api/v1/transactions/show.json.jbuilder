json.extract! @transaction, :id, :name, :created_at
if @transaction.bank_guarantee
  json.bank_guarantee_id @transaction.bank_guarantee.id
end
