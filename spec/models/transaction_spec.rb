require "rails_helper"

RSpec.describe Transaction do
  let(:transaction) { create(:transaction) }

  describe "validations" do
    it { expect(transaction).to be_valid }
    
    it "validates name" do
      transaction.name = nil
      expect(transaction).to be_invalid
    end
    
    it "validates company_id" do
      transaction.company_id = nil
      expect(transaction).to be_invalid
    end
  end

  describe "#deactivate!" do
    it "deactivates transaction" do
      expect{ transaction.deactivate! }.to change{ transaction.active }.from(true).to(false)
    end
    
    context "for transaction with bank_guarantee" do
      let(:transaction) { create(:transaction, :with_bank_guarantee) }
      
      it "deactivates transaction" do
        expect{ transaction.deactivate! }.to change{ transaction.active }.from(true).to(false)
      end
      
      it "deactivates bank_guarantee" do
        expect{ transaction.deactivate! }.to change{ transaction.bank_guarantee.active }.from(true).to(false)
      end
    end
  end
end
