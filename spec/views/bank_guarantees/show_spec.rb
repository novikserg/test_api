require "rails_helper"

describe "api/v1/bank_guarantees/show.json.jbuilder" do
  let(:bank_guarantee) { create(:bank_guarantee, created_at: DateTime.new(2017, 1, 1)) }

  it "returns bank_guarantee" do
    assign(:bank_guarantee, bank_guarantee)
    render
    result = JSON.parse(rendered)

    expect(result).to eq({
      "id" => 1,
      "transaction_id" => 1,
      "created_at" => "2017-01-01T00:00:00.000Z"
    })
  end
end
