RSpec.shared_examples "unauthorized request" do |method, url|
  it "returns unauthorized" do
    send(method, url)
    expect(response.code).to eq("401")
    expect(json_response).to eq({ "errors" => ["Authorized users only."] })
  end
end
