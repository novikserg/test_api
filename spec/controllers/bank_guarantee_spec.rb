require "rails_helper"

RSpec.describe Api::V1::BankGuaranteesController do
  let!(:company)     { create(:company) }
  let!(:transaction) { create(:transaction, company: company) }
  let(:bank_guarantee) { create(:bank_guarantee, current_transaction: transaction, company: company) }

  before :each do
    request.headers["accept"] = "application/json"
    token_sign_in(company)
  end

  describe "GET show" do
    before do
      get :show, params: { transaction_id: transaction.id, id: bank_guarantee.id }
    end
    
    it "assigns @bank_guarantee" do
      expect(assigns(:bank_guarantee)).to eq(bank_guarantee)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end
  end
  
  describe "POST create" do
    def do_action
      post :create, params: { transaction_id: transaction.id, bank_guarantee: params }
    end

    context "for correct params" do
      let(:params) { { transaction_id: transaction.id, active: true } }

      it "creates a BankGuarantee" do
        expect{ do_action }.to change{ company.bank_guarantees.count }.by(1)
        bank_guarantee = company.bank_guarantees.last
        expect(bank_guarantee.transaction_id).to eq(transaction.id)
        expect(bank_guarantee.active).to eq(true)
      end

      it "renders the show template" do
        do_action
        expect(response).to render_template(:show)
      end

      it "returns 201" do
        do_action
        expect(response.status).to eq(201)
      end
    end

    context "for invalid params" do
      let(:params) { { transaction_id: transaction.id, active: nil } }
      
      it "does not create a bank guarantee" do
        expect{ do_action }.not_to change{ BankGuarantee.count }
      end

      it "renders errors" do
        do_action
        expect(json_response).to eq({ "active" => ["is not included in the list"] })
      end

      it "returns 422" do
        do_action
        expect(response.status).to eq(422)
      end
    end
  end

  describe "PUT update" do
    let!(:new_transaction) { create(:transaction, company: company) }

    def do_action
      put :update, params: { transaction_id: transaction.id, id: bank_guarantee.id, bank_guarantee: params }
    end

    context "for correct params" do
      let(:params) { { transaction_id: new_transaction.id } }

      it "updates transaction" do
        expect{ do_action }.to change{ bank_guarantee.reload.transaction_id }.from(transaction.id).to(new_transaction.id)
      end

      it "renders the show template" do
        do_action
        expect(response).to render_template(:show)
      end

      it "returns 200" do
        do_action
        expect(response.status).to eq(200)
      end
    end
    
    context "for invalid params" do
      let(:params) { { transaction_id: "123" } }
      
      it "does not update a transaction" do
        expect{ do_action }.not_to change{ bank_guarantee.transaction_id }
      end
    
      it "renders the error" do
        do_action
        expect(json_response).to eq({ "current_transaction" => ["must exist"] })
      end
  
      it "returns 422" do
        do_action
        expect(response.status).to eq(422)
      end
    end
  end
  
  describe "DELETE destroy" do
    def do_action
      delete :destroy, params: { transaction_id: transaction.id, id: bank_guarantee.id }
    end
    
    it "sets active to false" do
      expect{ do_action }.to change{ bank_guarantee.reload.active }.from(true).to(false)
    end
    
    it "returns 204" do
      do_action
      expect(response.status).to eq(204)
    end
  end
end
