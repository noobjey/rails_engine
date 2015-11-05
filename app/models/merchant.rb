class Merchant < ActiveRecord::Base
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :invoices
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoice_items

  include Findable

  def revenue(date = nil)
    return revenue_for_date(date) unless date.nil?

    self.invoice_items.successful.calculate_cost
  end

  def revenue_for_date(date)
    self.invoice_items.revenue_for_date(date)
  end

  def favorite_customer
    self.customers.successful_transaction.group('customers.id').order('count(customers.id) DESC').first
  end
end
