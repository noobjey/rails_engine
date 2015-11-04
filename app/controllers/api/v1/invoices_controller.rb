class Api::V1::InvoicesController < Api::V1::BaseController

  def index
    super(Invoice)
  end

  def show
    super(Invoice)
  end

  def find
    super(Invoice)
  end

  def find_all
    super(Invoice)
  end

  def random
    super(Invoice)
  end

  def merchant
    respond_with current_invoice.merchant
  end

  def customer
    respond_with current_invoice.customer
  end

  def invoice_items
    respond_with current_invoice.invoice_items
  end

  def items
    respond_with current_invoice.items
  end

  def transactions
    respond_with current_invoice.transactions
  end


  private

  def allowed_params
    params.permit(:id, :status, :customer_id, :merchant_id, :created_at, :updated_at)
  end

  def current_invoice
    Invoice.find(params[:id])
  end
end
