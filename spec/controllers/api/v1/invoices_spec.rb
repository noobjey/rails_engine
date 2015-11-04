require 'rails_helper'
require 'support/parser_helper'

RSpec.describe Api::V1::InvoicesController, type: :controller do
  include ParserHelper

  describe 'Item Api:' do

    let!(:customer) { Customer.create!({ first_name: 'Happy', last_name: 'Gilmore' }) }
    let!(:merchant) { Merchant.create(name: 'I am Merchant') }
    let!(:invoice) { Invoice.create({ customer_id: customer.id, merchant_id: merchant.id, status: 'shipped' }) }
    let!(:item) { Item.create({ name: 'Item Thing', description: 'Some details', unit_price: 2, merchant_id: merchant.id }) }
    let!(:item2) { Item.create({ name: 'Item Thing 2', description: 'Some details', unit_price: 2, merchant_id: merchant.id }) }
    let!(:invoice_item1) { InvoiceItem.create(item_id: item.id, invoice_id: invoice.id) }
    let!(:invoice_item2) { InvoiceItem.create(item_id: item2.id, invoice_id: invoice.id) }
    let!(:transaction1) { Transaction.create(invoice_id: invoice.id) }
    let!(:transaction2) { Transaction.create(invoice_id: invoice.id) }

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

    it '#invoice_items' do
      invoice_items = InvoiceItem.all

      get :invoice_items, id: invoice.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(invoice_items.count)
      expect(parsed_response.first[:id]).to be_in(invoice_items.pluck(:id))
    end

    it '#items' do
      items = Item.all

      get :items, id: invoice.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(items.count)
      expect(parsed_response.first[:id]).to be_in(items.pluck(:id))
    end

    it '#merchant' do
      get :merchant, id: invoice.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(merchant.id)
      expect(parsed_response[:name]).to eq(merchant.name)
    end

    it '#customer' do
      get :customer, id: invoice.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(customer.id)
      expect(parsed_response[:first_name]).to eq(customer.first_name)
    end

    it '#transaction' do
      transactions = Transaction.all

      get :transactions, id: invoice.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(transactions.count)
      expect(parsed_response.first[:id]).to eq(transaction1.id)
      expect(parsed_response.last[:id]).to eq(transaction2.id)
    end
  end
end

