RSpec.shared_examples "authorized-only" do
  it "returns unauthorized" do
    expect(response).to be_unauthorized
    expect(response.body).to eq I18n.t("devise.failure.unauthenticated")
  end
end
