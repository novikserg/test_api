class Api::V1::BankGuaranteesController < ApplicationController
  before_action :authenticate_company!
  before_action :set_bank_guarantee, only: [:show, :update, :destroy]

  def show
  end

  def create
    @bank_guarantee = current_company.bank_guarantees.create!(bank_guarantee_params)

    respond_to do |format|
      format.json { render :show, status: :created }
    end
  end

  def update
    @bank_guarantee.update!(bank_guarantee_params)

    respond_to do |format|
      format.json { render :show, status: :ok }
    end
  end

  def destroy
    @bank_guarantee.deactivate!
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_guarantee
      @bank_guarantee = current_company.bank_guarantees.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_guarantee_params
      params.require(:bank_guarantee).permit(:active, :transaction_id)
    end
end
