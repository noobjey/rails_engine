class Invoice < ActiveRecord::Base
  belongs_to :customer
  belongs_to :merchant
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  include Findable

  def self.pending
    joins(:transactions).where(transactions: { result: 'failed' })
  end
end
