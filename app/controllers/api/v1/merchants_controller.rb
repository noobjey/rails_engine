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
    respond_with current_merchant.invoices
  end

  def items
    respond_with current_merchant.items
  end

  def revenue

    if allowed_params[:date] && allowed_params[:id]
      result = { revenue: current_merchant.revenue_for_date(allowed_params[:date]) }
    elsif allowed_params[:date]
      result = { total_revenue: InvoiceItem.revenue_for_date(allowed_params[:date]) }
    else
      result = { revenue: current_merchant.revenue }
    end

    respond_with result
  end


  def favorite_customer
    respond_with current_merchant.customers.joins(:transactions).where(transactions: { result: 'success' }).group('customers.id').order('count(customers.id) DESC').first
  end

  def customers_with_pending_invoices
    respond_with current_merchant.invoices.joins(:transactions).where(transactions: { result: 'failed' }).joins(:customer).uniq
  end

  def most_revenue
    merchant_total_revenue = InvoiceItem.all.joins(:invoice).joins(:transactions).where(transactions: { result: 'success' }).group('invoices.merchant_id').sum('unit_price * quantity')
    merchant_ids           = merchant_total_revenue.sort_by { |k, v| v }.reverse.first(params[:quantity].to_i).map(&:first)
    merchants              = merchant_ids.map { |id| Merchant.find(id) }
    respond_with merchants
  end


  private

  def allowed_params
    params.permit(:id, :name, :created_at, :updated_at, :date, :quantity)
  end

  def current_merchant
    Merchant.find(allowed_params[:id])
  end

end
