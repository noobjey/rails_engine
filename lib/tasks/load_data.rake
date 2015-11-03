require 'CSV'

namespace :rails_engine do
  desc "Load Customer Data"
  task load_customer: :environment do
    file_location = "#{Rails.root}/db/data/customers.csv"

    CSV.foreach(file_location, headers: true, header_converters: :symbol) do |row|
      Customer.create!(row.to_hash)
    end
  end

  desc "Load Invoice Data"
  task load_invoice: :environment do
    file_location = "#{Rails.root}/db/data/invoices.csv"

    CSV.foreach(file_location, headers: true, header_converters: :symbol) do |row|
      Invoice.create!(row.to_hash)
    end
  end

  desc "Load Invoice Items Data"
  task load_invoice_item: :environment do
    file_location = "#{Rails.root}/db/data/invoice_items.csv"

    CSV.foreach(file_location, headers: true, header_converters: :symbol) do |row|
      row[:unit_price] = row[:unit_price].insert(-3, '.').to_d
      InvoiceItem.create!(row.to_hash)
    end
  end

  desc "Load Item Data"
  task load_item: :environment do
    file_location = "#{Rails.root}/db/data/items.csv"

    CSV.foreach(file_location, headers: true, header_converters: :symbol) do |row|
      row[:unit_price] = row[:unit_price].insert(-3, '.').to_d
      Item.create!(row.to_hash)
    end
  end

  desc "Load Merchant Data"
  task load_merchant: :environment do
    file_location = "#{Rails.root}/db/data/merchants.csv"

    CSV.foreach(file_location, headers: true, header_converters: :symbol) do |row|
      Merchant.create!(row.to_hash)
    end
  end

  desc "Load Transaction Data"
  task load_transaction: :environment do
    file_location = "#{Rails.root}/db/data/transactions.csv"

    CSV.foreach(file_location, headers: true, header_converters: :symbol) do |row|
      Transaction.create!(row.to_hash)
    end
  end

  desc "Load All Data"
  task load_all: :environment do
    Rake::Task["rails_engine:load_customer"].invoke
    Rake::Task["rails_engine:load_merchant"].invoke
    Rake::Task["rails_engine:load_item"].invoke
    Rake::Task["rails_engine:load_invoice"].invoke
    Rake::Task["rails_engine:load_invoice_item"].invoke
    Rake::Task["rails_engine:load_transaction"].invoke
  end
end
