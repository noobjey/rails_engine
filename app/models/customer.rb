class Customer < ActiveRecord::Base
  include Filterable

  scope :first_name, -> (first_name) { where first_name: first_name }
  scope :last_name, -> (last_name) { where last_name: last_name }
  scope :id, -> (id) { where id: id }

  has_many :invoices
end
