class Api::V1::BankGuaranteesController < ApplicationController
  before_action :set_bank_guarantee, only: [:show, :update]

  def show
  end

  def create
    @bank_guarantee = BankGuarantee.new(bank_guarantee_params)

    respond_to do |format|
      if @bank_guarantee.save
        format.json { render :show, status: :created }
      else
        format.json { render json: @bank_guarantee.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @bank_guarantee.update(bank_guarantee_params)
        format.json { render :show, status: :ok }
      else
        format.json { render json: @bank_guarantee.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    set_bank_guarantee
    @bank_guarantee.deactivate!
    head :no_content
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_bank_guarantee
      @bank_guarantee = BankGuarantee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_guarantee_params
      params.require(:bank_guarantee).permit(:active, :transaction_id)
    end
end
