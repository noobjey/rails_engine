class Customer < ActiveRecord::Base
  has_many :invoices
  has_many :merchants, through: :invoices
  has_many :transactions, through: :invoices


  include Findable

  def favorite_merchant
    self.merchants.successful_transactions.group('merchants.id').order('count(merchants.id) DESC').first
  end

  def self.successful_transaction
    joins(:transactions).where(transactions: { result: 'success' })
  end

end
