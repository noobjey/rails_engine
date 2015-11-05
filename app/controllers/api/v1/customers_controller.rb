class Api::V1::CustomersController < Api::V1::BaseController

  def index
    super(Customer)
  end

  def show
    super(Customer)
  end

  def find
    super(Customer)
  end

  def find_all
    super(Customer)
  end

  def random
    super(Customer)
  end

  def invoices
    respond_with Customer.find(params[:id]).invoices
  end

  def transactions
    respond_with Transaction.joins(:invoice).where(["customer_id = ?", params[:id]])
  end

  def favorite_merchant
    respond_with Customer.find(params[:id]).favorite_merchant
  end
  
  private

  def allowed_params
    params.permit(:id, :first_name, :last_name, :created_at, :updated_at)
  end
end
