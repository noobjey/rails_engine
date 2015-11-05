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

    if allowed_params[:date]
      d = allowed_params[:date].to_date
      date_range = d.beginning_of_day..d.end_of_day
      rev = Merchant.find(allowed_params[:id]).invoice_items.joins(:invoice).where(invoices: {created_at: date_range}).joins(:transactions).where(transactions: {result: 'success'}).sum('unit_price * quantity')
    else
      rev = Merchant.find(allowed_params[:id]).invoice_items.joins(:transactions).where(transactions: {result: 'success'}).sum('unit_price * quantity')
    end

    result = {revenue: rev}
    respond_with result
  end

  def favorite_customer
    respond_with Merchant.find(allowed_params[:id]).customers.joins(:transactions).where(transactions: {result: 'success'}).group('customers.id').order('count(customers.id) DESC').first
  end

  def customers_with_pending_invoices
    respond_with Merchant.find(allowed_params[:id]).invoices.joins(:transactions).where(transactions: {result: 'failed'}).joins(:customer).uniq
  end


  private

  def allowed_params
    params.permit(:id, :name, :created_at, :updated_at, :date)
  end
end
