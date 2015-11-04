class Api::V1::ItemsController < Api::V1::BaseController

  def index
    super(Item)
  end

  def show
    super(Item)
  end

  def find
    super(Item)
  end

  def find_all
    super(Item)
  end

  def random
    super(Item)
  end

  # GET /api/v1/items/:id/invoice_items returns a collection of associated invoice items
  def invoice_items
    respond_with Item.find(params[:id]).invoice_items
  end

  # GET /api/v1/items/:id/merchant returns the associated merchant
  def merchant
    respond_with Item.find(params[:id]).merchant
  end

  private

  def allowed_params
    params.permit(:id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at)
  end
end
