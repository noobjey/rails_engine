require 'rails_helper'
require 'support/parser_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
  include ParserHelper

  describe 'Item Api:' do

    let!(:merchant) { Merchant.create(name: 'I am Merchant') }
    let!(:item) { Item.create({ name: 'Item Thing', description: 'Some details', unit_price: 2, merchant_id: merchant.id }) }
    let!(:invoice_item1) { InvoiceItem.create(item_id: item.id) }
    let!(:invoice_item2) { InvoiceItem.create(item_id: item.id) }

    let!(:other_item) { Item.create({ name: 'Item Thing2', merchant_id: merchant.id }) }
    let!(:same_name_item) { Item.create({ name: item.name, merchant_id: merchant.id }) }


    it '#index' do
      get :index, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(Item.count)
      expect(parsed_response.first[:name]).to eq(item.name)
      expect(parsed_response.last[:name]).to eq(same_name_item.name)
    end

    it '#show' do
      get :show, id: item.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:name]).to eq(item.name)
    end

    it '#find by id' do
      get :find, id: item.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(item.id)
    end

    it '#find by first name' do
      get :find, name: item.name, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(item.id)
    end

    it '#find_all' do
      same_name_count = Item.where(name: same_name_item.name).count

      get :find_all, name: same_name_item.name, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(same_name_count)
      expect(parsed_response.first[:id]).to eq(item.id)
      expect(parsed_response.last[:id]).to eq(same_name_item.id)
    end

    it '#random' do
      valid_ids = Item.all.pluck(:id)

      get :random, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to be_in(valid_ids)
    end

    it '#invoice_items' do
      invoice_items = InvoiceItem.all

      get :invoice_items, id: item.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response.count).to eq(invoice_items.count)
      expect(parsed_response.first[:id]).to be_in(invoice_items.pluck(:id))
    end

    it '#merchant' do
      get :merchant, id: item.id, format: :json

      expect(response.status).to eq(200)
      expect(parsed_response[:id]).to eq(merchant.id)
      expect(parsed_response[:name]).to eq(merchant.name)
    end
  end
end

