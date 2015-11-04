class Api::V1::InvoiceItemsController < Api::V1::BaseController

  def index
    super(InvoiceItem)
  end

  def show
    super(InvoiceItem)
  end

  def find
    super(InvoiceItem)
  end

  def find_all
    super(InvoiceItem)
  end

  def random
    super(InvoiceItem)
  end


  private

  def allowed_params
    params.permit(:id, :unit_price, :quantity, :item_id, :invoice_id, :created_at, :updated_at)
  end

end
