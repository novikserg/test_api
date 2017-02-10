require "rails_helper"

describe "api/v1/transactions/index.json.jbuilder" do
  let(:company) { create(:company) }
  let!(:transactions) { create_list(:transaction, 2, company: company, created_at: DateTime.new(2017, 1, 1)) }
  
  it "returns transactions" do
    assign(:transactions, transactions)
    render
    result = JSON.parse(rendered)

    expect(result).to eq(
      { "transactions" => [
          { "id" => transactions.first.id,  "name" => "New Transaction", "created_at" => "2017-01-01T00:00:00.000Z", "status" => nil},
          { "id" => transactions.second.id, "name" => "New Transaction", "created_at" => "2017-01-01T00:00:00.000Z", "status" => nil} ]
      })
  end
end
  