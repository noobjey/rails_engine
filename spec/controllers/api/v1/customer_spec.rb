require 'rails_helper'
require 'support/parser_helper'

RSpec.describe Api::V1::CustomersController, type: :controller do
  include ParserHelper

  describe 'Customer Api:' do

    let!(:customer) { Customer.create!({ first_name: 'Happy', last_name: 'Gilmore' }) }
    let!(:merchant) { Merchant.create(name: 'I am Merchant') }
    let!(:invoice1) { Invoice.create(customer_id: customer.id, merchant_id: merchant, status: 'shipped') }
    let!(:transaction1) { Transaction.create(invoice_id: invoice1.id) }
    let!(:invoice2) { Invoice.create(customer_id: customer.id, merchant_id: merchant, status: 'shipped') }
    let!(:transaction2) { Transaction.create(invoice_id: invoice2.id) }
    let!(:other_customer) { Customer.create({ first_name: 'Someone', last_name: 'Else' }) }
    let!(:same_name_customer) { Customer.create({ first_name: customer.first_name, last_name: 'Different' }) }

    it '#index' do
      get :index, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(Customer.count)
      expect(parsed_response.first[:first_name]).to eq(customer.first_name)
      expect(parsed_response.last[:first_name]).to eq(same_name_customer.first_name)
    end

    it '#show' do
      get :show, id: customer.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:first_name]).to eq(customer.first_name)
      expect(parsed_response[:last_name]).to eq(customer.last_name)
    end

    it '#find by id' do
      get :find, id: customer.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(customer.id)
    end

    it '#find by first name' do
      get :find, first_name: customer.first_name, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(customer.id)
    end

    it '#find by ignores case' do
      get :find, last_name: customer.last_name.downcase, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(customer.id)
    end

    it '#find_all' do
      same_first_name_count = Customer.where(first_name: same_name_customer.first_name).count

      get :find_all, first_name: same_name_customer.first_name, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(same_first_name_count)
      expect(parsed_response.first[:id]).to eq(customer.id)
      expect(parsed_response.last[:id]).to eq(same_name_customer.id)
    end

    it '#random' do
      valid_ids = Customer.all.pluck(:id)
      get :random, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to be_in(valid_ids)
    end

    it '#invoices' do
      invoices = Invoice.all
      get :invoices, id: customer.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(invoices.count)
      expect(parsed_response.first[:id]).to be_in(invoices.pluck(:id))
    end

    it '#transactions' do
      transactions = Transaction.all
      get :transactions, id: customer.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(transactions.count)

      expect(parsed_response.first[:id]).to be_in(transactions.pluck(:id))
    end
  end
end
