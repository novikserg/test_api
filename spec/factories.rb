FactoryGirl.define do
  factory :company do
    email "yeti@iceberg.com"
    password "testtest"
  end

  factory :transaction do
    name "New Transaction"
    active true
    company
    
    trait :with_bank_guarantee do
      bank_guarantee
    end
  end
  
  factory :bank_guarantee do
    active true
    association :current_transaction, factory: :transaction
    
    before(:create) do |bank_guarantee|
      bank_guarantee.company = bank_guarantee.current_transaction.company
    end
  end
end
