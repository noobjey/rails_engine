require 'rails_helper'
require 'support/parser_helper'

RSpec.describe Api::V1::InvoiceItemsController, type: :controller do
  include ParserHelper

  describe 'Invoice Items Api:' do

    let!(:customer) { Customer.create!({ first_name: 'Happy', last_name: 'Gilmore' }) }
    let!(:merchant) { Merchant.create(name: 'I am Merchant') }
    let!(:invoice1) { Invoice.create({ customer_id: customer.id, merchant_id: merchant.id, status: 'shipped' }) }
    let!(:invoice2) { Invoice.create({ customer_id: customer.id, merchant_id: merchant.id, status: 'shipped' }) }
    let!(:item1) { Item.create({ name: 'Item Thing', description: 'Some details', unit_price: 2, merchant_id: merchant.id }) }
    let!(:item2) { Item.create({ name: 'Item Thing 2', description: 'Some details', unit_price: 2, merchant_id: merchant.id }) }

    let!(:invoice_item) { InvoiceItem.create(item_id: item1.id, invoice_id: invoice1.id, quantity: 3, unit_price: 22.22) }
    let!(:other_invoice_item) { InvoiceItem.create(item_id: item2.id, invoice_id: invoice1.id, quantity: 2, unit_price: 33.33) }
    let!(:same_price_invoice_item) { InvoiceItem.create(item_id: item2.id, invoice_id: invoice2.id, quantity: 5, unit_price: 22.22) }


    it '#index' do
      get :index, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(InvoiceItem.count)
      expect(parsed_response.first[:id]).to eq(invoice_item.id)
      expect(parsed_response.last[:id]).to eq(same_price_invoice_item.id)
    end

    it '#show' do
      get :show, id: invoice_item.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(invoice_item.id)
    end

    it '#find by id' do
      get :find, id: invoice_item.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(invoice_item.id)
    end

    it '#find by attribute' do
      get :find, unit_price: other_invoice_item.unit_price, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:unit_price]).to eq(other_invoice_item.unit_price.to_s)
    end

    it '#find_all' do
      same_price_count = InvoiceItem.where(unit_price: invoice_item.unit_price).count

      get :find_all, unit_price: same_price_invoice_item.unit_price, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(same_price_count)
      expect(parsed_response.first[:id]).to eq(invoice_item.id)
      expect(parsed_response.last[:id]).to eq(same_price_invoice_item.id)
    end

    it '#random' do
      valid_ids = InvoiceItem.all.pluck(:id)

      get :random, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to be_in(valid_ids)
    end


    # GET /api/v1/invoice_items/:id/invoice returns the associated invoice
    # GET /api/v1/invoice_items/:id/item returns the associated item
    # it '#merchant' do
    #   get :merchant, id: invoice.id, format: :json
    #
    #   expect(response.status).to eq(200)
    #   expect(parsed_response[:id]).to eq(merchant.id)
    #   expect(parsed_response[:name]).to eq(merchant.name)
    # end
  end
end

