require "rails_helper"

describe "api/v1/transactions/show.json.jbuilder" do
  let(:transaction) { create(:transaction, created_at: DateTime.new(2017, 1, 1)) }

  before do
    assign(:transaction, transaction)
  end
  
  it "returns transaction" do
    render

    result = JSON.parse(rendered)

    expect(result).to eq({
      "id"   => 1,
      "name" => "New Transaction",
      "created_at"=>"2017-01-01T00:00:00.000Z"
    })
  end
  
  context "with bank_guarantee" do
    let!(:bank_guarantee) { create(:bank_guarantee, current_transaction: transaction, company: transaction.company) }
    
    it "returns transaction with bank_guarantee_id" do
      render
      result = JSON.parse(rendered)
  
      expect(result).to eq ({
        "id" => 1,
        "name"=>"New Transaction",
        "created_at" => "2017-01-01T00:00:00.000Z",
        "bank_guarantee_id" => 1
      })
    end
  end
end
