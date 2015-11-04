class Customer < ActiveRecord::Base
  has_many :invoices

  include Findable
end
