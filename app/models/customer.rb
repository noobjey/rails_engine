class Customer < ActiveRecord::Base
  has_many :invoices
  has_many :merchants, through: :invoices
  has_many :transactions, through: :invoices

  include Findable

  def self.successful_transaction
    joins(:transactions).where(transactions: { result: 'success' })
  end
end
