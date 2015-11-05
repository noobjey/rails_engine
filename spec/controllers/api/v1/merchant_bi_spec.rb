require 'rails_helper'
require 'support/parser_helper'

RSpec.describe Api::V1::MerchantsController, type: :controller do
  include ParserHelper

  describe 'Merchant Bi Api' do

    let!(:customer1) { Customer.create(first_name: 'Happy') }
    let!(:merchant1) { Merchant.create(name: 'The Merchant') }
    let!(:merchant2) { Merchant.create(name: 'The Merchant 2') }
    let!(:invoice1) { Invoice.create(merchant_id: merchant1.id, customer_id: customer1.id, created_at: Date.today) }
    let!(:invoice2) { Invoice.create(merchant_id: merchant1.id, customer_id: customer1.id, created_at: Date.yesterday) }
    let!(:invoice3) { Invoice.create(merchant_id: merchant1.id, customer_id: customer1.id, created_at: Date.yesterday) }
    let!(:invoice4) { Invoice.create(merchant_id: merchant2.id, customer_id: customer1.id, created_at: Date.yesterday) }
    let!(:invoice_item1) { InvoiceItem.create(invoice_id: invoice1.id, quantity: 2, unit_price: 2.22) }
    let!(:invoice_item2) { InvoiceItem.create(invoice_id: invoice2.id, quantity: 3, unit_price: 3.33) }
    let!(:invoice_item3) { InvoiceItem.create(invoice_id: invoice3.id, quantity: 3, unit_price: 3.33) }
    let!(:invoice_item4) { InvoiceItem.create(invoice_id: invoice4.id, quantity: 4, unit_price: 103.33) }
    let!(:transaction1) { Transaction.create(invoice_id: invoice1.id, result: 'success') }
    let!(:transaction2) { Transaction.create(invoice_id: invoice2.id, result: 'success') }
    let!(:transaction3) { Transaction.create(invoice_id: invoice3.id, result: 'failed') }
    let!(:transaction3) { Transaction.create(invoice_id: invoice4.id, result: 'success') }



    it '#revenue' do
      total_revenue = cost([invoice_item1, invoice_item2])

      get :revenue, id: merchant1.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:revenue]).to eq(total_revenue.to_s)
    end

    it '#revenue_for_date' do
      total_revenue = cost([invoice_item1])

      get :revenue_for_date, date: invoice1.created_at, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:total_revenue]).to eq(total_revenue.to_s)
    end

    it '#favorite_customer' do
      get :favorite_customer, id: merchant1.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(customer1.id)
      expect(parsed_response[:first_name]).to eq(customer1.first_name)
    end

    it '#customers_with_pending_invoices' do
      get :favorite_customer, id: merchant1.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:first_name]).to eq(customer1.first_name)
    end

    it '#most_revenue' do
      get :most_revenue, quantity: 2, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.first[:id]).to eq(merchant2.id)
      expect(parsed_response.first[:name]).to eq(merchant2.name)
    end

    private

    def cost(invoice_items)
      invoice_items.sum { |invoice_item| invoice_item.quantity * invoice_item.unit_price }
    end
  end
end
