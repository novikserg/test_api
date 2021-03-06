require "rails_helper"

RSpec.describe ApiErrors do
  def do_action
    get :index, params: {}
  end

  describe "unprocessable entity" do
    controller(ApplicationController) do
      def index
        record = Transaction.create!
      end
    end

    it "returns 422" do
      do_action
      expect(response.status).to eq(422)
    end
  end
  
  describe "not found" do
    controller(ApplicationController) do
      def index
        record = Transaction.find(12345)
      end
    end

    it "returns 404" do
      do_action
      expect(response.status).to eq(404)
    end
  end
  
  describe "bad request" do
    controller(ApplicationController) do
      def index
        params.require(:param)
      end
    end

    it "returns 404" do
      do_action
      expect(response.status).to eq(400)
    end
  end
end
