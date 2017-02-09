require "rails_helper"

RSpec.describe Api::V1::TransactionsController do
  let!(:company) { Company.create(email: "yeti@pepsi.com", password: "testtest") }

  def token_sign_in(company)
    auth_headers = company.create_new_auth_token
    request.headers.merge!(auth_headers)
  end

  before :each do
    request.headers["accept"] = "application/json"
    token_sign_in(company)
  end

  describe "GET show" do
    let(:transaction) { Transaction.create(name: "s") }
    
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
        expect{ do_action }.to change{ Transaction.count }.by(1)
        transaction = Transaction.last
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
    let!(:transaction) { Transaction.create(name: "l") }
    
    def do_action
      put :update, params: { id: transaction.id , transaction: params }
    end
    
    context "for correct params" do
      let(:params) { { name: "name", status: "blabla"} }
      
      it "updates transaction" do
        expect{ do_action }.to change{ transaction.reload.name }.from("l").to("name")
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
      let(:params) { { name: "", status: "blabla" } }
      
      it "does not update a transaction" do
        do_action
        transaction.reload
        expect(transaction.name).to eq "l"
        expect(transaction.status).to eq nil
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
  
  describe "DELETE destroy" do
    let!(:transaction) { Transaction.create(name: "s", active: true) }
    let!(:bank_guarantee) { BankGuarantee.create(transaction_id: transaction.id, active: true) }
    
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
