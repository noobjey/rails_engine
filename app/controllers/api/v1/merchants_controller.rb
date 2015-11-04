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
    respond_with Merchant.find(params[:id]).invoices
  end

  def items
    respond_with Merchant.find(params[:id]).items
  end

  private

  def allowed_params
    params.permit(:id, :name)
  end
end
