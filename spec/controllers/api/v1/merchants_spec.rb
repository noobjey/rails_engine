require 'rails_helper'
require 'support/parser_helper'

RSpec.describe Api::V1::MerchantsController, type: :controller do
  include ParserHelper

  describe "Merchant Api" do

    let!(:merchant) { Merchant.create(name: 'The Merchant') }
    let!(:invoice1) { Invoice.create(merchant_id: merchant.id) }
    let!(:invoice2) { Invoice.create(merchant_id: merchant.id) }
    let!(:item1) { Item.create(merchant_id: merchant.id) }
    let!(:item2) { Item.create(merchant_id: merchant.id) }
    let!(:merchant2) { Merchant.create(name: 'The Merchant 2') }
    let!(:same_name_merchant) { Merchant.create(name: 'The Merchant') }


    it '#index' do
      get :index, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(Merchant.count)
      expect(parsed_response.first[:name]).to eq(merchant.name)
      expect(parsed_response.last[:name]).to eq(same_name_merchant.name)
    end

    it '#show' do
      get :show, id: merchant.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:name]).to eq(merchant.name)
    end

    it '#find by id' do
      get :find, id: merchant.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(merchant.id)
    end

    it '#find by first name' do
      get :find, name: merchant.name, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(merchant.id)
    end

    it '#find_all' do
      same_name_count = Merchant.where(name: same_name_merchant.name).count

      get :find_all, name: same_name_merchant.name, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(same_name_count)
      expect(parsed_response.first[:id]).to eq(merchant.id)
      expect(parsed_response.last[:id]).to eq(same_name_merchant.id)
    end

    it '#random' do
      valid_ids = Merchant.all.pluck(:id)
      get :random, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to be_in(valid_ids)
    end

    it '#invoice' do
      get :invoices, id: merchant.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(Invoice.count)
      expect(parsed_response.first[:id]).to eq(invoice1.id)
      expect(parsed_response.last[:id]).to eq(invoice2.id)
    end

    it '#items' do
      get :items, id: merchant.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(Item.count)
      expect(parsed_response.first[:id]).to eq(item1.id)
      expect(parsed_response.last[:id]).to eq(item2.id)
    end
  end
end
