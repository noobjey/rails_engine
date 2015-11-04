class Api::V1::TransactionsController < Api::V1::BaseController

  def index
    super(Transaction)
  end

  def show
    super(Transaction)
  end

  def find
    super(Transaction)
  end

  def find_all
    super(Transaction)
  end

  def random
    super(Transaction)
  end

  def invoice
    respond_with Transaction.find(params[:id]).invoice
  end

  private

  def allowed_params
    params.permit(:id, :result, :credit_card_number, :invoice_id, :created_at, :updated_at)
  end

end
