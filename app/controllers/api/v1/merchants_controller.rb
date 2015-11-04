class Api::V1::MerchantsController < Api::V1::BaseController

  def index
    super(Merchant)
  end

  def show
    super(Merchant)
  end

  def find
    super(Merchant)
  end

  def find_all
    super(Merchant)
  end

  def random
    super(Merchant)
  end

  def invoices
    respond_with Merchant.find(allowed_params[:id]).invoices
  end

  def items
    respond_with Merchant.find(allowed_params[:id]).items
  end

  def revenue
    rev = Merchant.find(allowed_params[:id]).invoice_items.joins(:transactions).where(transactions: {result: 'success'}).sum('unit_price * quantity')
    result = {revenue: rev}
    respond_with result
  end


# GET /api/v1/merchants/:id/revenue returns the total revenue for that merchant across all transactions
# GET /api/v1/merchants/:id/revenue?date=x returns the total revenue for that merchant for a specific invoice date x
# GET /api/v1/merchants/:id/favorite_customer returns the customer who has conducted the most successful transactions
# GET /api/v1/merchants/:id/customers_with_pending_invoices returns a collection of customers which have pending (unpaid) invoices

# NOTE: Failed charges should never be counted in revenue totals or statistics.
# NOTE: All revenues should be reported as a float with two decimal places.

  private

  def allowed_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
