require "rails_helper"

RSpec.describe Api::V1::BankGuaranteesController, type: :request do
  let!(:bank_guarantee) { create(:bank_guarantee) }
  let(:company)         { bank_guarantee.company }
  let(:transaction)     { bank_guarantee.current_transaction }

  describe "#show" do
    context "for unauthorized company" do
      it_behaves_like "unauthorized request", :get, "/api/v1/transactions/1/bank_guarantees/1"
    end
  
    context "for authorized company" do
      it "returns transactions" do
        authorized_get(company, "/api/v1/transactions/#{transaction.id}/bank_guarantees/#{bank_guarantee.id}")
        expect(response.body).to include(bank_guarantee.transaction_id.to_s)
      end
    end
  end
end
