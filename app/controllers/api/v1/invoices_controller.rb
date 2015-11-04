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


  private

  def allowed_params
    params.permit(:id, :status, :customer_id, :merchant_id, :created_at, :updated_at)
  end
end
