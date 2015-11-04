require 'rails_helper'
require 'support/parser_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do
  include ParserHelper

  describe 'Transaction Api:' do

    let!(:customer) { Customer.create!({ first_name: 'Happy', last_name: 'Gilmore' }) }
    let!(:merchant) { Merchant.create(name: 'I am Merchant') }
    let!(:invoice1) { Invoice.create({ customer_id: customer.id, merchant_id: merchant.id, status: 'shipped' }) }

    let!(:transaction) { Transaction.create(invoice_id: invoice1.id, credit_card_number: '11111111111', result: 'unsuccess') }
    let!(:other_transaction) { Transaction.create(invoice_id: invoice1.id, credit_card_number: '2222222222', result: 'success') }
    let!(:same_result_transaction) { Transaction.create(invoice_id: invoice1.id, credit_card_number: '3333333333', result: transaction.result) }

    it '#index' do
      get :index, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(Transaction.count)
      expect(parsed_response.first[:id]).to eq(transaction.id)
      expect(parsed_response.last[:id]).to eq(same_result_transaction.id)
    end

    it '#show' do
      get :show, id: transaction.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(transaction.id)
    end

    it '#find by id' do
      get :find, id: transaction.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(transaction.id)
    end

    it '#find by attribute' do
      get :find, result: transaction.result, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:result]).to eq(transaction.result)
    end

    it '#find_all' do
      same_result_count = Transaction.where(result: transaction.result).count

      get :find_all, result: same_result_transaction.result, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(same_result_count)
      expect(parsed_response.first[:id]).to eq(transaction.id)
      expect(parsed_response.last[:id]).to eq(same_result_transaction.id)
    end

    it '#random' do
      valid_ids = Transaction.all.pluck(:id)

      get :random, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to be_in(valid_ids)
    end

    it '#merchant' do
      get :invoice, id: transaction.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(invoice1.id)
    end

  end
end

