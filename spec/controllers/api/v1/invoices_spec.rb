require 'rails_helper'
require 'support/parser_helper'

RSpec.describe Api::V1::InvoicesController, type: :controller do
  include ParserHelper

  describe 'Item Api:' do

    let!(:customer) { Customer.create!({ first_name: 'Happy', last_name: 'Gilmore' }) }
    let!(:merchant) { Merchant.create(name: 'I am Merchant') }
    let!(:invoice) { Invoice.create({ customer_id: customer.id, merchant_id: merchant.id, status: 'shipped' }) }

    let!(:other_invoice) { Invoice.create({ customer_id: customer.id, merchant_id: merchant.id, status: 'lost' }) }
    let!(:same_status_invoice) { Invoice.create({ customer_id: customer.id, merchant_id: merchant.id, status: 'shipped' }) }


    it '#index' do
      get :index, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(Invoice.count)
      expect(parsed_response.first[:id]).to eq(invoice.id)
      expect(parsed_response.last[:id]).to eq(same_status_invoice.id)
    end

    it '#show' do
      get :show, id: invoice.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(invoice.id)
    end

    it '#find by id' do
      get :find, id: invoice.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(invoice.id)
    end

    it '#find by attribute' do
      get :find, status: invoice.status, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:status]).to eq(invoice.status)
    end

    it '#find_all' do
      same_name_count = Invoice.where(status: invoice.status).count

      get :find_all, status: same_status_invoice.status, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(same_name_count)
      expect(parsed_response.first[:id]).to eq(invoice.id)
      expect(parsed_response.last[:id]).to eq(same_status_invoice.id)
    end

    it '#random' do
      valid_ids = Invoice.all.pluck(:id)

      get :random, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to be_in(valid_ids)
    end

    # GET /api/v1/invoices/:id/transactions returns a collection of associated transactions
    # GET /api/v1/invoices/:id/invoice_items returns a collection of associated invoice items
    # GET /api/v1/invoices/:id/items returns a collection of associated items
    # GET /api/v1/invoices/:id/customer returns the associated customer
    # GET /api/v1/invoices/:id/merchant returns the associated merchant
    # it '#invoice_items' do
    #   invoice_items = InvoiceItem.all
    #
    #   get :invoice_items, id: item.id, format: :json
    #
    #   expect(response.status).to eq(200)
    #   expect(parsed_response.count).to eq(invoice_items.count)
    #   expect(parsed_response.first[:id]).to be_in(invoice_items.pluck(:id))
    # end
    #
    # it '#merchant' do
    #   get :merchant, id: item.id, format: :json
    #
    #   expect(response.status).to eq(200)
    #   expect(parsed_response[:id]).to eq(merchant.id)
    #   expect(parsed_response[:name]).to eq(merchant.name)
    # end
  end
end

