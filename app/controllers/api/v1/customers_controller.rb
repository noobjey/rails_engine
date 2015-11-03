class Api::V1::CustomersController < ApplicationController

  def index
    respond_with Customer.all
  end

  def show
    respond_with Customer.find(params[:id])
  end

  def find
    respond_with Customer.filter(filter_params).first
  end

  def find_all
    respond_with Customer.filter(filter_params)
  end

  def random
    respond_with Customer.all.sample(1)
  end

  def invoices
    respond_with Customer.find(params[:id]).invoices
  end

  def transactions
    respond_with Transaction.joins(:invoice).where(["customer_id = ?", params[:id] ] )
  end

  private

  def filter_params
    params.slice(:id, :first_name, :last_name)
  end
end
