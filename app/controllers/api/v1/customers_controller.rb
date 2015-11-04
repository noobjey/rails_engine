class Api::V1::CustomersController < ApplicationController

  def index
    respond_with Customer.all
  end

  def show
    respond_with Customer.find(params[:id])
  end

  def find
    respond_with Customer.insensitive_find_by(customer_params).first
  end

  def find_all
    respond_with Customer.where(customer_params)
  end

  def random
    respond_with Customer.all.sample(1).first
  end

  def invoices
    respond_with Customer.find(params[:id]).invoices
  end

  def transactions
    respond_with Transaction.joins(:invoice).where(["customer_id = ?", params[:id]])
  end

  def favorite_merchant
    # byebug
    # GET /api/v1/customers/:id/favorite_merchant returns a merchant where the customer has conducted the most successful transactions
    # merchant who customer has invoices with
    # was thinking doing a merge but not sure
    # all invoices with successful transactions
    #   Invoice.where(customer_id: params[:id]).joins(:transact).where(["result = ?", "success" ])
  end

  private

  def customer_params
    params.permit(:id, :first_name, :last_name)
  end
end
