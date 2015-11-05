class InvoiceItem < ActiveRecord::Base
  belongs_to :item
  belongs_to :invoice
  has_many :transactions, through: :invoice

  include Findable

  def self.successful
    joins(:transactions).where(transactions: { result: 'success' })
  end

  def self.calculate_cost
    sum('unit_price * quantity')
  end

  def self.revenue_for_date(date)
    all.joins(:invoice).where(invoices: { created_at: date}).successful.calculate_cost
  end
end
