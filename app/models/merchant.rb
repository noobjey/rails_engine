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

  def customers_with_pending_invoices
    self.invoices.pending.joins(:customer).uniq
  end

  def self.highest_revenues(top ="1")
    Merchant.all.joins(:invoice_items).merge(InvoiceItem.successful)
      .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
      .group('merchants.id')
      .order('total_revenue DESC').limit(top)
  end

  def self.successful_transactions
    joins(:transactions).where(transactions: { result: 'success' })
  end
end
