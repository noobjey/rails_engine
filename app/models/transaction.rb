class Transaction < ActiveRecord::Base
  belongs_to :invoice

  scope :successful, -> { where(result: 'success') }

  include Findable
end
