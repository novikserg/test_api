class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_company!
  before_action :set_transaction, only: [:show, :update, :destroy]

  def show
  end

  def create
    @transaction = Transaction.create!(transaction_params)

    respond_to do |format|
      format.json { render :show, status: :created }
    end
  end

  def update
    @transaction.update!(transaction_params)

    respond_to do |format|
      format.json { render :show, status: :ok }
    end
  end

  def destroy
    @transaction.deactivate!
    head :no_content
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:name,:importer_id, :exporter_id, :status)
    end
end
