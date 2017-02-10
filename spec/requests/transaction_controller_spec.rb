require "rails_helper"

RSpec.describe Api::V1::TransactionsController, type: :request do
  def json
    JSON.parse(response.body)
  end
  
  let!(:company)      { create(:company) }
  let!(:transactions) { create_list(:transaction, 2, company: company) }
  let(:transaction)   { transactions.first }

  describe "#index" do
    context "for unauthorized company" do
      it_behaves_like "unauthorized request", :get, "/api/v1/transactions"
    end

    context "for authorized company" do
      it "returns transactions" do
        authorized_get(company, "/api/v1/transactions")
        expect(response.body).to include(transaction.name)
      end
    end
  end
  
  describe "#create" do
    context "for unauthorized company" do
      it_behaves_like "unauthorized request", :post, "/api/v1/transactions"
    end

    context "for authorized company" do
      let(:params) { { transaction: { name: "Some Transaction" } } }
    
      it "creates a transaction" do
        authorized_post(company, "/api/v1/transactions", params)
        expect(response.body).to include("Some Transaction")
      end
    end
  end
  
  describe "#show" do
    context "for unauthorized company" do
      it_behaves_like "unauthorized request", :get, "/api/v1/transactions/1"
    end

    context "for authorized company" do
      it "returns transactions" do
        authorized_get(company, "/api/v1/transactions/#{transaction.id}")
        expect(response.body).to include(transaction.name)
      end
    end
  end
  
  describe "#update" do
    let(:params) { { transaction: { name: "Some Transaction" } } }

    context "for unauthorized company" do
      it_behaves_like "unauthorized request", :put, "/api/v1/transactions/1"
    end

    context "for authorized company" do
      it "returns transactions" do
        authorized_put(company, "/api/v1/transactions/#{transaction.id}", params)
        expect(response.body).to include("Some Transaction")
      end
    end
  end
  
  describe "#delete" do
    context "for unauthorized company" do
      it_behaves_like "unauthorized request", :delete, "/api/v1/transactions/1"
    end

    context "for authorized company" do
      it "returns transactions" do
        authorized_delete(company, "/api/v1/transactions/#{transaction.id}")
        expect(response.body).to eq("")
      end
    end
  end
end
