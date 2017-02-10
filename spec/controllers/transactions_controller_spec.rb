require "rails_helper"

RSpec.describe Api::V1::TransactionsController do
  let!(:company) { create(:company) }
  let!(:transaction) { create(:transaction, company: company) }

  before :each do
    request.headers["accept"] = "application/json"
    token_sign_in(company)
  end

  describe "GET show" do
    before do
      get :show, params: { id: transaction.id }
    end
    
    it "assigns @transaction" do
      expect(assigns(:transaction)).to eq(transaction)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end
  end
  
  describe "POST create" do
    def do_action
      post :create, params: { transaction: params }
    end
    
    context "for correct params" do
      let(:params) { { name: "name"} }
      
      it "creates a transaction" do
        expect{ do_action }.to change{ company.transactions.count }.by(1)
        transaction = company.transactions.last
        expect(transaction.name).to eq("name")
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
      let(:params) { { status: "123" } }
      
      it "does not create a transaction" do
        expect{ do_action }.not_to change{ Transaction.count }
      end

      it "renders the error" do
        do_action
        expect(JSON.parse(response.body)).to eq({ "name" => ["can't be blank"] })
      end
      
      it "returns 422" do
        do_action
        expect(response.status).to eq(422)
      end
    end
  end
  
  describe "PUT update" do
    def do_action
      put :update, params: { id: transaction.id , transaction: params }
    end
    
    context "for correct params" do
      let(:params) { { name: "name", status: "some string"} }
      
      it "updates transaction" do
        expect{ do_action }.to change{ transaction.reload.name }.from("New Transaction").to("name")
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
      let(:params) { { name: "", status: "some string" } }
      
      before { do_action }
      
      it "does not update a transaction" do
        transaction.reload
        expect(transaction.name).to eq "New Transaction"
        expect(transaction.status).to eq nil
      end
    
      it "renders the error" do
        expect(JSON.parse(response.body)).to eq({ "name" => ["can't be blank"] })
      end

      it "returns 422" do
        expect(response.status).to eq(422)
      end
    end
  end
  
  describe "DELETE destroy" do
    let!(:bank_guarantee) { create(:bank_guarantee, current_transaction: transaction) }
    
    def do_action
      delete :destroy, params: { id: transaction.id }
    end
    
    it "sets active to false" do
      expect{ do_action }.to change{ transaction.reload.active }.from(true).to(false)
    end
    
    it "sets bank_guarantee active to false" do
      expect{ do_action }.to change{ bank_guarantee.reload.active }.from(true).to(false)
    end
    
    it "returns 204" do
      do_action
      expect(response.status).to eq(204)
    end
  end
end
