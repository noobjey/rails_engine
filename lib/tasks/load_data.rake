require 'CSV'

namespace :rails_engine do
  desc "Load Customer Data"
  task :load_customer => :environment do
    file_location = "#{Rails.root}/db/data/customers.csv"


    CSV.foreach(file_location, headers: true, header_converters: :symbol) do |row|
      Customer.create!(row.to_hash)
    end
  end

end
