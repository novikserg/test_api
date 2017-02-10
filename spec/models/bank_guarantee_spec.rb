require "rails_helper"

RSpec.describe BankGuarantee do
  let(:bank_guarantee) { create(:bank_guarantee) }

  describe "validations" do
    it { expect(bank_guarantee).to be_valid }
    
    it "validates transaction_id" do
      bank_guarantee.transaction_id = nil
      expect(bank_guarantee).to be_invalid
    end
    
    it "validates company_id" do
      bank_guarantee.company_id = nil
      expect(bank_guarantee).to be_invalid
    end
    
    it "validates active" do
      bank_guarantee.active = nil
      expect(bank_guarantee).to be_invalid
      
      bank_guarantee.active = true
      expect(bank_guarantee).to be_valid

      bank_guarantee.active = false
      expect(bank_guarantee).to be_valid
    end
  end

  describe "#deactivate!" do
    it "deactivates bank guarantee" do
      expect{ bank_guarantee.deactivate! }.to change{ bank_guarantee.active }.from(true).to(false)
    end
  end
end
