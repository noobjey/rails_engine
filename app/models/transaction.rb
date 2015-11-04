class Transaction < ActiveRecord::Base
  belongs_to :invoice

  include Findable
end
