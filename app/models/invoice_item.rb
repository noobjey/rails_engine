class InvoiceItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :invoice

  include Findable
end
